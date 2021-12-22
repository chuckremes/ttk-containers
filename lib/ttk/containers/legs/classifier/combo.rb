# frozen_string_literal: true
require_relative 'helpers'

module TTK
  module Containers
    module Legs
      module Classifier
        # Given a grouped set of legs that mimics a valid Order, this method determines
        # the type of Options Combo from its construction.
        #
        # e.g. given 2 legs, same callput, same strike, different expirations, returns :calendar
        # or :reverse_calendar depending on the long/short of the front month
        #
        # Repro rules table here from README.
        #
        #  P/C   |  Leg#  | Expiration#  |  Strike#  | Near S/L   | Far S/L | Near O/C  |  Far O/C  | Name
        # P or C |    2   |     1        |    2      | long       | short   |  opening  |  opening  | long vertical
        # P or C |    2   |     1        |    2      | short      | long    |  opening  |  opening  | short vertical
        # P or C |    2   |     1        |    2      | s or l     | s or l  |  opening  |  closing  | roll_in
        # P or C |    2   |     1        |    2      | s or l     | s or l  |  closing  |  opening  | roll_out
        # P or C |    2   |     2        |    1      | short      | long    |  opening  |  opening  | calendar
        # P or C |    2   |     2        |    1      | long       | short   |  opening  |  opening  | reverse calendar
        # P or C |    2   |     2        |    1      | s or l     | s or l  |  closing  |  opening  | roll_out
        # P or C |    2   |     2        |    1      | s or l     | s or l  |  opening  |  closing  | roll_in
        # P or C |    2   |     2        |    2      | short      | long    |  opening  |  opening  | diagonal
        # P or C |    2   |     2        |    2      | long       | short   |  opening  |  opening  | reverse diagonal
        # P or C |    2   |     2        |    2      | s or l     | s or l  |  opening  |  closing  | roll_in
        # P or C |    2   |     2        |    2      | s or l     | s or l  |  closing  |  opening  | roll_out
        # P or C |    4   |     1        |    4      | short      | long    |  opening  |  opening  | condor
        # P or C |    4   |     1        |    4      | long       | short   |  opening  |  opening  | reverse condor
        # P or C |    4   |     1        |    3      | short      | long    |  opening  |  opening  | butterfly
        # P or C |    4   |     1        |    3      | long       | short   |  opening  |  opening  | reverse butterfly
        # P or C |    4   |     2        |    2      | short      | long    |  opening  |  opening  | condor calendar
        # P or C |    4   |     2        |    2      | long       | short   |  opening  |  opening  | reverse condor calendar
        # P or C |    4   |     2        |    2      | s or l     | s or l  |  closing  |  opening  | roll_out
        # P or C |    4   |     2        |    2      | s or l     | s or l  |  opening  |  closing  | roll_in
        # P & C  |    4   |     2        |    2      | short      | long    |  opening  |  opening  | iron calendar
        # P & C  |    4   |     2        |    2      | long       | short   |  opening  |  opening  | reverse iron calendar
        # P & C  |    2   |     1        |    1      | long       | long    |  opening  |  opening  | straddle
        # P & C  |    2   |     1        |    1      | short      | short   |  opening  |  opening  | reverse straddle
        # P & C  |    2   |     1        |    2      | long       | long    |  opening  |  opening  | strangle
        # P & C  |    2   |     1        |    2      | short      | short   |  opening  |  opening  | reverse strangle
        # E & C  |    2   |     1        |    1      | long       | short   |  opening  |  opening  | covered call
        # E & P  |    2   |     1        |    1      | short      | short   |  opening  |  opening  | covered put
        # E & P  |    2   |     1        |    1      | long       | long    |  opening  |  opening  | married put
        class Combo
          UnknownComboStructure = Class.new(StandardError)

          # Determine 3 things at the beginning:
          #   1. All calls, puts, or a mix?
          #   2. How many legs?
          #   3. How many expirations?
          #
          # From this we can rapidly determine the appropriate type.
          #
          def self.classify(legs_array)
            case legs_array.count
            when 1 then One.classify(legs_array)
            when 2 then Two.classify(legs_array)
            when 4 then Four.classify(legs_array)
            else
              raise UnhandledLegCount, "No idea how to classify with #{legs.count} legs!"
            end
          end

          class One
            def self.classify(legs)
              leg = legs.first

              if leg.equity_option?
                :equity_option
              elsif leg.equity?
                :equity
              else
                raise UnknownComboStructure.new
              end
            end
          end

          class Two
            extend Classifier::Helpers

            def self.classify(legs)
              if all_calls?(legs)
                calls(legs_array)
              elsif all_puts?(legs)
                puts(legs_array)
              elsif putcall_mix?(legs)
                mix(legs_array)
              else
                raise UnknownComboStructure.new
              end
            end

            def self.puts(legs)
              case leg_count(legs)
              when 2
                PotentialVertical.classify(legs)
              when 4
                PotentialCondor.classify(legs)
              else
                UnknownComboStructure.new
              end
            end
          end

          class PotentialVertical
            extend Classifier::Helpers

            def self.classify(legs)
              case expiration_count(legs)
              when 1
                one_expiration(legs)
              when 2
                two_expiration(legs)
              else
                raise UnknownComboStructure.new
              end
            end

            def self.one_expiration(legs)
              # must have two strikes, so look at opening / closing
              return :vertical if all_opening?(legs)
              :roll
            end

            def self.two_expiration(legs)
              # may have one or two strikes
              case strike_count(legs)
              when 1
                return :calendar if all_opening?(legs)
                return :roll_in if near_leg(legs).opening? && far_leg(legs).closing?
                return :roll_out if near_leg(legs).closing? && far_leg(legs).opening?
                raise UnknownComboStructure.new
              when 2
              else
                raise UnknownComboStructure.new
              end
            end
          end

          class Four
            extend Classifier::Helpers

            def self.classify(legs_array)

            end
          end

          def old
            # clarity over performance... besides, leg count will always be a small integer
            leg_count        = legs_array.count
            all_calls        = legs_array.all?(&:call?)
            all_puts         = legs_array.all?(&:put?)
            mix              = legs_array.any?(&:equity?) || (!all_calls && !all_puts)
            expiration_count = legs_array.map { |leg| leg.expiration_date.date }.uniq.size

            if leg_count == 1
              # # solo leg!
              # leg = legs_array.first
              # return :equity_option if leg.equity_option?
              # return :equity if leg.equity?
            elsif all_puts
              case leg_count
              when 2
                return :vertical_spread if expiration_count == 1

                if expiration_count > 1
                  strike_count = container.legs.map(&:strike).uniq.count
                  return :calendar_spread if strike_count == 1
                  return :diagonal_spread if strike_count > 1
                else
                  raise "#{call}: how did i get here? A"
                end

              when 4
                case expiration_count
                when 1
                  :butterfly
                when 2
                  :spread_roll
                else
                  raise "#{call}: how did i get here? B"
                end
              else
                raise "#{self.class}.figure_unknown, all_puts with leg_count [#{leg_count}] is unhandled!"
              end
            else
              binding.pry
              raise "#{self.class}.figure_unknown, all_calls [#{all_calls}], all_puts [#{all_puts}], mix [#{mix}], expiration_count [#{expiration_count}], leg_count [#{leg_count}], unhandled combination! #{container.inspect}"
            end
          end
        end
      end
    end
  end
end
