# frozen_string_literal: true
require 'forwardable'

module TTK
  module Containers
    module Legs
      module Classifier

        # Common functions that other Classifier classes may need to perform their classification work
        #
        module Helpers
          TooManyExpirations = Class.new(StandardError)
          Needs4Legs = Class.new(StandardError)
          BadLegCount = Class.new(StandardError)

          DirectionContainer = Struct.new(:legs, keyword_init: true) do
            include Enumerable

            def each
              legs.each { |leg| yield(leg) }
            end

            def opening?
              all?(&:opening?)
            end

            def closing?
              all?(&:closing?)
            end

            def short?
              # assumes sorted, always pick the first leg of the container
              first.short?
            end

            def long?
              !short?
            end
          end

          def leg_count(legs)
            legs.count
          end

          def expiration_count(legs)
            value = legs.map { |l| l.expiration.date }.uniq.count
            raise TooManyExpirations, "Container has #{value} expirations!" if value > 2

            value
          end

          def strike_count(legs)
            legs.map(&:strike).uniq.count
          end

          def put_count(legs)
            legs.count { |leg| leg.put? }
          end

          def call_count(legs)
            legs.count { |leg| leg.call? }
          end

          def equity_count(legs)
            legs.count { |leg| leg.equity? }
          end

          def sort(legs)
            # sigh, ruby doesn't have a stable sort so we need to rely on this index hack,
            # see here for details:
            # https://medium.com/store2be-tech/stable-vs-unstable-sorting-2943b1d13977
            if legs.all? { |l| l.put? }
              legs.sort_by.with_index { |leg, i| [-leg.strike, i] }
                  .sort_by.with_index { |leg, i| [leg.expiration.date, i] }
            else
              # note that a mix of calls and puts could be in this array
              # so we just use ascending strike order as the default;
              # besides, it's dumb to invert calls and puts
              legs.sort_by.with_index { |leg, i| [leg.strike, i] }
                  .sort_by.with_index { |leg, i| [leg.expiration.date, i] }
            end
          end

          # Return the front month leg with the nearest expiration
          def near_leg(legs)
            sort(legs).first
          end

          # Return the back month leg with the latest expiration
          def far_leg(legs)
            sort(legs).last
          end

          # Return the pair of legs with the nearest expiration. Only valid
          # on 4-leg constructs. Wraps the legs in a special container that
          # only answers #opening? and #closing?
          #
          def near_legs(legs)
            raise Needs4Legs.new unless legs.count == 4
            pair = sort(legs).slice(0, 2)
            DirectionContainer.new(legs: pair)
          end

          def far_legs(legs)
            raise Needs4Legs.new unless legs.count == 4
            pair = sort(legs).slice(2, 2)
            DirectionContainer.new(legs: pair)
          end

          def all_puts?(legs)
            legs.all? { |leg| leg.put? }
          end

          def all_calls?(legs)
            legs.all? { |leg| leg.call? }
          end

          def putcall_mix?(legs)
            legs.any? { |leg| leg.put? } &&
              legs.any? { |leg| leg.call? }
          end

          def contains_equity?(legs)
            legs.any? { |leg| leg.equity? }
          end

          def all_opening?(legs)
            legs.all? { |leg| leg.opening? }
          end

          def all_closing?(legs)
            legs.all? { |leg| leg.closing? }
          end

          def open_close_mix?(legs)
            legs.any? { |leg| leg.opening? } &&
              legs.any? { |leg| leg.closing? }
          end

          # It's a roll when there's a mix of open & close operations
          def roll?(near, far)
            near.opening? && far.closing? ||
              near.closing? && far.opening?
          end

          def roll_in?(near, far)
            near.opening? && far.closing?
          end

          def roll_out?(near, far)
            near.closing? && far.opening?
          end

          def split_near_far(legs)
            sorted = sort(legs)

            case leg_count(legs)
            when 1
              [legs.first, nil]
            when 2
              [sorted.first, sorted.last]
            when 4
              [DirectionContainer.new(legs: sorted.slice(0, 2)), DirectionContainer.new(legs: sorted.slice(2, 2))]
            else
              raise BadLegCount.new
            end
          end
        end
      end
    end
  end
end
