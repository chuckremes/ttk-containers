module TTK
  module Containers
    module Product
      module Expiration

        Example = Struct.new(
          *Interface.required_methods, keyword_init: true) do

          include ComposedMethods
        end

      end
    end
  end
end
