module TTK
  module Containers
    module Quote

      # A concrete implementation of a Quote class using the shared definitions
      # in the Quote::Interface and Quote::ComposedMethods modules. A vendor
      # implementation would do something similar to this to expose that
      # vendor"s particular quote data structure to conform to the defined
      # Quote::Interface.
      #
      # This example concrete class will likely be used by TTK::Core and others
      # to do unit and integration tests since the interface (and behaviors)
      # should be identical to the vendors.
      #
      Example = Struct.new(
        *Interface.base_methods,
        keyword_init: true
      ) do

        include ComposedMethods
        include Product::Forward

        def update_quote(object)
          object.keys.each do |key|
            next if equity? && %i[dte multiplier open_interest intrinsic extrinsic
                                delta gamma theta vega rho iv].include?(key.to_sym)
            next if key.to_s =~ /multiplier/ # not allowed to be updated, ever

            if object[key]
              send("#{key}=", object[key])
            end
          end
        end

        def multiplier
          return 1 if equity?
          dig(:multiplier)
        end

        def open_interest
          return 0 if equity?
          dig(:open_interest)
        end

        def dte
          return 0 if equity?
          dig(:dte)
        end

        def extrinsic
          return 0.0 if equity?
          dig(:extrinsic)
        end

        def intrinsic
          return 0.0 if equity?
          dig(:intrinsic)
        end

        def delta
          return 0.0 if equity?
          dig(:delta)
        end

        def gamma
          return 0.0 if equity?
          dig(:gamma)
        end

        def theta
          return 0.0 if equity?
          dig(:theta)
        end

        def vega
          return 0.0 if equity?
          dig(:vega)
        end

        def rho
          return 0.0 if equity?
          dig(:rho)
        end

        def iv
          return 0.0 if equity?
          dig(:iv)
        end
      end

    end
  end
end
