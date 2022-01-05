# frozen_string_literal: true

module TTK
  module Containers
    module Legs
      module Position
        Example = Struct.new(*Interface.base_methods,
                             keyword_init: true) do
          include ComposedMethods
          extend ClassMethods

          def initialize(*)
            super
            self.legs = legs # forces a call through to #legs= to sort them
          end

          def legs=(array)
            # somewhat tricky
            # the `self[:legs]` call allows us to set the value for the Struct.
            # the call to #super should execute the #legs= defined in ComposedMethods
            # whereas #super has no meaning within a Struct normally
            self[:legs] = super(array)
          end
        end
      end
      module Order
        Example = Struct.new(*Interface.base_methods,
                             keyword_init: true) do
          include ComposedMethods
          extend ClassMethods

          def initialize(*)
            super
            self.legs = legs
          end

          def legs=(array)
            self[:legs] = super(array)
          end
        end
      end
    end
  end
end
