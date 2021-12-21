module TTK
  module Containers
    module Leg

      # Any concrete implementation of a Legs class from a vendor must provide
      # these elemental methods. The Leg::ComposedMethods methods will use some
      # of these too.
      module Interface
        def self.base_methods
          %i[
            product quote
            side unfilled_quantity filled_quantity execution_price
            order_price placed_time execution_time preview_time
            legs_status legs_id stop_price fees commission direction
          ]
        end

        def self.required_methods
          m = base_methods +
              ComposedMethods.public_instance_methods

          m.uniq.reject { |m| disallowed_methods.include?(m) }
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
        MultipleSymbolError = Class.new(StandardError)

        def symbol
          s = map(field: :symbol).uniq
          raise MultipleSymbolError.new(s.inspect) if s.size > 1

          s
        end

        def all?(field:)
          legs.all? { |leg| leg.send(field) }
        end

        def map(field:)
          legs.map { |leg| leg.send(field) }
        end

        # Greeks!

        def delta
        end

        def gamma
        end

        def theta
        end

        def vega
        end

        def rho
        end
      end

    end

  end
end
