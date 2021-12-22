# frozen_string_literal: true

module TTK
  module Containers
    module Legs
      module Classifier

        # Common functions that other Classifier classes may need to perform their classification work
        #
        module Helpers
          TooManyExpirations = Class.new(StandardError)

          def leg_count(legs)
            legs.count
          end

          def expiration_count(legs)
            value = legs.map(&:expiration_date).uniq.count
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
        end
      end
    end
  end
end
