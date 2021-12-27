# frozen_string_literal: true

module TTK
  module Containers
    module Legs
      module Position
        Example = Struct.new(*Interface.base_methods,
                             keyword_init: true) do
          include ComposedMethods
          extend ClassMethods
        end
      end
      module Order
        Example = Struct.new(*Interface.base_methods,
                             keyword_init: true) do
          include ComposedMethods
          extend ClassMethods
        end
      end
    end
  end
end
