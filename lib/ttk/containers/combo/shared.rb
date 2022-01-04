# frozen_string_literal: true

module TTK
  module Containers
    # A Combo is a container that contains multiple legs. We have two main structures
    # that can contain multiple legs which are Order and Position containers. Both
    # share a common structure so we pull that commonality into here. The Order and
    # Position Combos are defined explicitly elsewhere.
    #
    # Define all of the Combo types here along with their convenience methods such as
    # #anchor_strike, #body_strike, and other.
    #
    module Combo
    end
  end
end
