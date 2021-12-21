# frozen_string_literal: true

module TTK
  module Containers
    # A Combo is a container that contains multiple legs. We have two main structures
    # that can contain multiple legs which are Order and Position containers. Both
    # share a common structure so we pull that commonality into here. The Order and
    # Position Combos are defined explicitly elsewhere.
    #
    module Combo
      module Interface
        def self.required_methods
          []
        end
      end

      module Forward
        extend Forwardable
        def_delegators :legs, *Interface.required_methods
      end

      module ComposedMethods
      end
    end
  end
end
