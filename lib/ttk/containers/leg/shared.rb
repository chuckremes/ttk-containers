module TTK
  module Containers
    module Leg

      module Position
        # Any concrete implementation of a Leg class from a vendor must provide
        # these elemental methods. The Leg::ComposedMethods methods will use some
        # of these too.
        module Interface
          def self.required_methods
            [
              :product, :quote,
              :side, :unfilled_quantity, :filled_quantity, :execution_price,
              :order_price, :placed_time, :execution_time, :preview_time,
              :leg_status, :leg_id
            ]
          end
        end

        # The basic logic associated with any Leg Container. All leg containers must
        # implement the interface as defined in interface.rb. That concrete implementation
        # includes this shared module to round out the details
        module ComposedMethods
          # What used to be here has now permanently moved to Product. It didn't make sense
          # for #call? to be defined here when the Leg's Product will already support that
          # logic.
        end
      end

      module Order
        module Interface
          def self.required_methods
            [
              :product, :quote,
              :side, :unfilled_quantity, :filled_quantity, :execution_price,
              :order_price, :placed_time, :execution_time, :preview_time,
              :leg_status, :leg_id, :stop_price
            ]
          end
        end
      end

    end
  end
end
