module TTK
  module Containers
    module Leg

      EPOCH = Time.utc(1970, 1, 1, 0, 0, 0)

      # Any concrete implementation of a Leg class from a vendor must provide
      # these elemental methods. The Leg::ComposedMethods methods will use some
      # of these too.
      module Interface
        def self.base_methods
          [
            :product, :quote,
            :side, :unfilled_quantity, :filled_quantity, :execution_price,
            :order_price, :placed_time, :execution_time, :preview_time,
            :leg_status, :leg_id, :stop_price, :fees, :commission
          ]
        end

        def self.required_methods
          m = base_methods +
            ComposedMethods.public_instance_methods +
            Product::Interface.required_methods +
            Quote::Interface.required_methods

          # remove the duplicates, e.g. #delta from ComposedMethods, and #delta from Quote
          # and filter out Comparable methods
          m.uniq.reject { |m| disallowed_methods.include?(m) }
        end

        # We can"t include Comparable methods in our required list
        def self.disallowed_methods
          [:<=>, :clamp, :<=, :>=, :==, :<, :>, :between?]
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
          :long == side
        end

        def short?
          :short == side
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
