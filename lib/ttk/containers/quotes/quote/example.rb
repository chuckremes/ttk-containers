module TTK
  module Containers
    module Quotes
      module Quote

        # A concrete implementation of a Quote class using the shared definitions
        # in the Quote::Interface and Quote::ComposedMethods modules. A vendor
        # implementation would do something similar to this to expose that
        # vendor's particular quote data structure to conform to the defined
        # Quote::Interface.
        #
        # This example concrete class will likely be used by TTK::Core and others
        # to do unit and integration tests since the interface (and behaviors)
        # should be identical to the vendors.
        #
        Quote = Struct.new(
          *Quotes::Quote::Interface.required_methods,
          keyword_init: true
        ) do
          include Quotes::Quote::ComposedMethods
        end

      end
    end
  end
end
