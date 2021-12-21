# frozen_string_literal: true

module TTK
  module Containers
    module Legs
      Example = Struct.new(*Interface.base_methods,
                           keyword_init: true) do
        include ComposedMethods
        extend ClassMethods
      end
    end
  end
end
