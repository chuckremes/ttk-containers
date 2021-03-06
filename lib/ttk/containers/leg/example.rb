# frozen_string_literal: true

module TTK
  module Containers
    module Leg
      # The basic unit of an Order or Position.
      # We do not include actions like :buy_to_open at this level. That is inferred
      # from the Order body itself. Legs are either long or short.
      #
      # e.g. leg1 => long, leg2 => short
      #      order(leg1, leg2, :buy_to_open) => leg1=buy_to_open, leg2=sell_to_open
      #      order(leg1, leg2, :sell_to_close) => leg1=buy_to_close, leg2=sell_to_close
      #      order(leg1, leg2, :buy_to_close) => leg1=buy_to_close, leg2=sell_to_close
      #      order(leg1, leg2, :sell_to_open) => leg1=buy_to_open, leg2=sell_to_open
      #
      # The action can change based on the container. The container enforces the real
      # action onto the legs.
      #
      Example = Struct.new(*Interface.base_methods,
                           keyword_init: true) do
        # Order of inclusion is important. The #delta method in ComposedMethods needs to
        # load last so any call to #super will trigger that method on Quote::Forward
        include Quote::Forward
        include Product::Forward
        include ComposedMethods
      end
    end
  end
end
