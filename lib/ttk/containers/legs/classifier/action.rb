# frozen_string_literal: true
require_relative 'helpers'

module TTK
  module Containers
    module Legs
      module Classifier
        # Takes an array of Leg objects as an input and returns the inferred
        # action.
        #
        # Todo: move tests from legs_spec into a classifier_spec and make it shareable. Then legs_spec
        # can run the shared specs indirectly via the #action method.
        #
        class Action
          UnhandledLegCount = Class.new(StandardError)

          def self.classify(legs)
            case legs.count
            when 1 then One.classify(legs)
            when 2 then Two.classify(legs)
            when 3 then Three.classify(legs)
            when 4 then Four.classify(legs)
            else
              raise UnhandledLegCount, "No idea how to classify with #{legs.count} legs!"
            end
          end

          class One
            UnknownSecurityType = Class.new(StandardError)

            def self.classify(legs)
              leg = legs.first

              if leg.equity?
                return :buy if leg.long?
                return :sell if leg.short?
                raise UnknownSecurityType, "Inspect leg.product to determine type #{leg.product.inspect}"
              elsif leg.equity_option?
                return :buy_to_open if leg.long? && leg.opening?
                return :buy_to_close if leg.long? && leg.closing?
                return :sell_to_open if leg.short? && leg.opening?
                return :sell_to_close if leg.short? && leg.closing?
                raise UnknownSecurityType, "Inspect leg.product to determine type #{leg.product.inspect}"
              else
                raise UnknownSecurityType, "Inspect leg.product to determine type #{leg.product.inspect}"
              end
            end
          end

          class Two
            extend Classifier::Helpers

            UnknownTwoLegType = Class.new(StandardError)

            def self.classify(legs)
              case expiration_count(legs)
              when 1
                vertical(legs)
              when 2
                diagonal(legs)
              end
            end

            def self.diagonal(legs)
              return :roll_in if roll?(legs) && near_leg(legs).opening?
              return :roll_out if roll?(legs) && near_leg(legs).closing?

              return :sell_to_open if near_leg(legs).short? && near_leg(legs).opening?
              return :buy_to_open if near_leg(legs).long? && near_leg(legs).opening?
              return :sell_to_close if near_leg(legs).short? && near_leg(legs).closing?
              return :buy_to_close if near_leg(legs).long? && near_leg(legs).closing?

              binding.pry
              raise UnknownTwoLegType
            end

            def self.vertical(legs)
              return :roll if roll?(legs)

              # if we get here then we know it's a normal vertical
              return :sell_to_open if near_leg(legs).short? && near_leg(legs).opening?
              return :buy_to_open if near_leg(legs).long? && near_leg(legs).opening?
              return :sell_to_close if near_leg(legs).short? && near_leg(legs).closing?
              return :buy_to_close if near_leg(legs).long? && near_leg(legs).closing?

              raise UnknownTwoLegType
            end
          end

          class Four
            extend Classifier::Helpers

            UnknownFourLegType = Class.new(StandardError)

            def self.classify(legs)
              case expiration_count(legs)
              when 1
                iron_condor(legs)
              when 2
                iron_calendar(legs)
              when 4
                raise UnknownFourLegType
              end
            end

            def self.iron_condor(legs)
              return :roll_in if roll?(legs) && near_leg(legs).opening?
              return :roll_out if roll?(legs) && near_leg(legs).closing?

              return :sell_to_open if near_leg(legs).short? && near_leg(legs).opening?
              return :buy_to_open if near_leg(legs).long? && near_leg(legs).opening?
              return :sell_to_close if near_leg(legs).short? && near_leg(legs).closing?
              return :buy_to_close if near_leg(legs).long? && near_leg(legs).closing?

              raise UnknownFourLegType
            end

            def self.iron_calendar(legs)
              return :roll_in if roll?(legs) && near_leg(legs).opening?
              return :roll_out if roll?(legs) && near_leg(legs).closing?

              return :sell_to_open if near_leg(legs).short? && near_leg(legs).opening?
              return :buy_to_open if near_leg(legs).long? && near_leg(legs).opening?
              return :sell_to_close if near_leg(legs).short? && near_leg(legs).closing?
              return :buy_to_close if near_leg(legs).long? && near_leg(legs).closing?

              raise UnknownFourLegType
            end
          end
        end
      end
    end
  end
end
