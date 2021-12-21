# frozen_string_literal: true

module TTK
  module Containers
    module Legs
      module Classifier
        # Takes an array of Leg objects as an input and returns the inferred
        # action.
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

          module Helpers
            TooManyExpirations = Class.new(StandardError)

            def expiration_count(legs)
              value = legs.map(&:expiration_date).uniq.count
              raise TooManyExpirations, "Container has #{value} expirations!" if value > 2

              value
            end

            def strike_count(legs)
              legs.map(&:strike).uniq.count
            end

            def sort(legs)
              # sigh, ruby doesn't have a stable sort so we need to rely on this index hack,
              # see here for details:
              # https://medium.com/store2be-tech/stable-vs-unstable-sorting-2943b1d13977
              if legs.all? {|l| l.put? }
                legs.sort_by.with_index { |leg, i| [-leg.strike, i] }
                    .sort_by.with_index { |leg, i| [leg.expiration_date.date, i] }
              else
                # note that a mix of calls and puts could be in this array
                # so we just use ascending strike order as the default;
                # besides, it's dumb to invert calls and puts
                legs.sort_by.with_index { |leg, i| [leg.strike, i] }
                    .sort_by.with_index { |leg, i| [leg.expiration_date.date, i] }
              end
            end

            def near_leg(legs)
              sort(legs).first
            end

            def far_leg(legs)
              sort(legs).last
            end

            # It's a roll when there's a mix of open & close operations
            def roll?(legs)
              near_leg(legs).opening? && far_leg(legs).closing? ||
                near_leg(legs).closing? && far_leg(legs).opening?
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
            extend Helpers

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
            extend Helpers

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
