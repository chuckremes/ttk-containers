# frozen_string_literal: true

module TTK
  module Containers
    module Leg
      EPOCH = Time.utc(1970, 1, 1, 0, 0, 0)

      # Any concrete implementation of a Leg class from a vendor must provide
      # these elemental methods. The Leg::ComposedMethods methods will use some
      # of these too.
      module Interface
        def self.base_methods
          # #price should reflect the cost of the container
          # #market_price should reflect the cost using current quote
          %i[
            product quote
            side unfilled_quantity filled_quantity price stop_price
            market_price placed_time execution_time preview_time
            leg_status leg_id fees commission direction
          ]
        end

        def self.required_methods
          m = base_methods +
              ComposedMethods.public_instance_methods +
              Product::Interface.required_methods +
              Quote::Interface.required_methods

          m.uniq.reject { |d| disallowed_methods.include?(d) }
        end

        # We can"t include Comparable methods in our required list
        def self.disallowed_methods
          %i[<=> clamp <= >= == < > between?]
        end
      end

      # The basic logic associated with any Leg Container. All leg containers must
      # implement the interface as defined in interface.rb. That concrete implementation
      # includes this shared module to round out the details
      module ComposedMethods
        # What used to be here has now permanently moved to Product. It didn't make sense
        # for #call? to be defined here when the Leg's Product will already support that
        # logic.

        def long?
          side == :long
        end

        def short?
          side == :short
        end

        def opening?
          direction == :opening
        end

        def closing?
          direction == :closing
        end

        # Greeks!
        # Defined here so each leg can adjust itself based on it
        # being a put/call and long/short
        # e.g. short put should have positive delta
        # FIXME: Needs documentation at the container level since
        # this could cause confusion in the future when computing
        # aggregate greeks for a spread. If the container uses
        # the quantity (positive and negative) for each leg then
        # that works against this logic here because the signs will
        # be flipped.

        def delta
          return super if long?

          -super
        end

        def gamma
          return super if long?

          -super
        end

        def theta
          return super if long?

          -super
        end

        def vega
          return super if long?

          -super
        end

        def rho
          return super if long?

          -super
        end
      end
    end
  end
end
