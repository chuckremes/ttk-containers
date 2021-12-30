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
        # P or C |    2   |     1        |    2      | long       | short   |  closing  |  closing  | long vertical
        # P or C |    2   |     1        |    2      | short      | long    |  closing  |  closing  | short vertical
        # P or C |    2   |     1        |    2      | s or l     | s or l  |  opening  |  closing  | roll_in
        # P or C |    2   |     1        |    2      | s or l     | s or l  |  closing  |  opening  | roll_out
        # P or C |    2   |     2        |    1      | short      | long    |  opening  |  opening  | calendar
        # P or C |    2   |     2        |    1      | long       | short   |  opening  |  opening  | reverse calendar
        # P or C |    2   |     2        |    1      | short      | long    |  closing  |  closing  | calendar
        # P or C |    2   |     2        |    1      | long       | short   |  closing  |  closing  | reverse calendar
        # P or C |    2   |     2        |    1      | s or l     | s or l  |  closing  |  opening  | roll_out
        # P or C |    2   |     2        |    1      | s or l     | s or l  |  opening  |  closing  | roll_in
        # P or C |    2   |     2        |    2      | short      | long    |  opening  |  opening  | diagonal
        # P or C |    2   |     2        |    2      | long       | short   |  opening  |  opening  | reverse diagonal
        # P or C |    2   |     2        |    2      | short      | long    |  closing  |  closing  | diagonal
        # P or C |    2   |     2        |    2      | long       | short   |  closing  |  closing  | reverse diagonal
        # P or C |    2   |     2        |    2      | s or l     | s or l  |  opening  |  closing  | roll_in
        # P or C |    2   |     2        |    2      | s or l     | s or l  |  closing  |  opening  | roll_out
        # P or C |    4   |     1        |    4      | short      | long    |  opening  |  opening  | condor
        # P or C |    4   |     1        |    4      | long       | short   |  opening  |  opening  | reverse condor
        # P or C |    4   |     1        |    3      | short      | long    |  opening  |  opening  | butterfly
        # P or C |    4   |     1        |    3      | long       | short   |  opening  |  opening  | reverse butterfly
        # P or C |    4   |     2        |    2      | short      | long    |  opening  |  opening  | condor calendar
        # P or C |    4   |     2        |    2      | long       | short   |  opening  |  opening  | reverse condor calendar
        # P or C |    4   |     1        |    4      | short      | long    |  closing  |  closing  | condor
        # P or C |    4   |     1        |    4      | long       | short   |  closing  |  closing  | reverse condor
        # P or C |    4   |     1        |    3      | short      | long    |  closing  |  closing  | butterfly
        # P or C |    4   |     1        |    3      | long       | short   |  closing  |  closing  | reverse butterfly
        # P or C |    4   |     2        |    2      | short      | long    |  closing  |  closing  | condor calendar
        # P or C |    4   |     2        |    2      | long       | short   |  closing  |  closing  | reverse condor calendar
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
          extend Helpers
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
            when 1
              One.classify(legs_array.first)
            when 2
              Two.classify(*split_near_far(legs_array), legs_array)
            when 4
              Four.classify(*split_near_far(legs_array), legs_array)
            else
              raise UnhandledLegCount, "No idea how to classify with #{legs.count} legs!"
            end
          end

          class One
            def self.classify(leg)
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

            def self.classify(near, far, legs)
              if all_calls?(legs)
                same(near, far, legs)
              elsif all_puts?(legs)
                same(near, far, legs)
              elsif putcall_mix?(legs)
                mix(near, far, legs)
              elsif contains_equity?(legs)
                covered(near, far, legs)
              else
                raise UnknownComboStructure.new
              end
            end

            def self.same(near, far, legs)
              case expiration_count(legs)
              when 1
                PotentialVertical.classify(near, far, legs)
              when 2
                PotentialCalendar.classify(near, far, legs)
              else
                raise UnknownComboStructure.new
              end
            end

            def self.covered(near, far, legs)
              return :covered if near.equity? && near.long? && far.equity_option? && far.short?
              return :covered if near.equity? && near.short? && far.equity_option? && far.short?
              raise UnknownComboStructure.new
            end
          end

          class PotentialVertical
            extend Classifier::Helpers

            def self.classify(near, far, legs)
              case strike_count(legs)
              when 1
                raise UnknownComboStructure.new
              when 2
                return :vertical if all_opening?(legs) || all_closing?(legs)
                return :vertical_roll if roll?(near, far)
                raise UnknownComboStructure.new
              when 3
                return :butterfly if all_opening?(legs) || all_closing?(legs)
                raise UnknownComboStructure.new
              when 4
                return :condor if all_opening?(legs) || all_closing?(legs)
                raise UnknownComboStructure.new
              end
            end
          end

          class PotentialCalendar
            extend Classifier::Helpers

            def self.classify(near, far, legs)
              # may have 1-4 strikes
              case strike_count(legs)
              when 1
                return :calendar if all_opening?(legs) || all_closing?(legs)
                return :calendar_roll if roll?(near, far)
                raise UnknownComboStructure.new
              when 2
                return :diagonal if all_opening?(legs) || all_closing?(legs)
                return :diagonal_roll if roll?(near, far)
                raise UnknownComboStructure.new
              when 3
                return :butterfly if all_opening?(legs) || all_closing?(legs)
                # not sure how a butterfly rolls...
                raise UnknownComboStructure.new
              when 4
                return :condor if all_opening?(legs) || all_closing?(legs)
                return :condor_roll if roll?(near, far)
                raise UnknownComboStructure.new
              else
                raise UnknownComboStructure.new
              end
            end
          end

          class Four
            extend Classifier::Helpers

            def self.classify(near, far, legs)
              if all_calls?(legs)
                same(near, far, legs)
              elsif all_puts?(legs)
                same(near, far, legs)
              elsif putcall_mix?(legs)
                mix(near, far, legs)
              else
                raise UnknownComboStructure.new
              end
            end

            def self.same(near, far, legs)
              case expiration_count(legs)
              when 1
                # condor or butterfly
                type = PotentialVertical.classify(near, far, legs)
                "spread_#{type}".to_sym
              when 2
                type = PotentialCalendar.classify(near, far, legs)
                "spread_#{type}".to_sym
              else
                raise UnknownComboStructure.new
              end
            end
          end

        end
      end
    end
  end
end
