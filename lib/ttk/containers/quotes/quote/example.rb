module TTK
  module Containers
    module Quotes
      module Quote

        module Equity
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
            include TTK::Containers::Product::Forward

            def update_quote(object)
              object.keys.each do |key|
                if object[key]
                  send("#{key}=", object[key])
                end
              end
            end
          end
        end

        module EquityOption
          Example = Struct.new(
            *Interface.base_methods,
            keyword_init: true
          ) do

            include ComposedMethods
            include TTK::Containers::Product::Forward

            def update_quote(object)
              object.keys.each do |key|
                next if key.to_s =~ /multiplier/

                if object[key]
                  send("#{key}=", object[key])
                end
              end
            end
          end
        end

      end
    end
  end
end
