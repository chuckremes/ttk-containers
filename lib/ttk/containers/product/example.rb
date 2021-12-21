# frozen_string_literal: true

module TTK
  module Containers
    module Product
      # A concrete definition of a Product. Note that some of the #required_methods
      # names come from the ComposedMethods module. They cannot be defined on the
      # Struct otherwise those accessors will override the module even after we
      # include it. We don"t call #super in them
      # because we don"t care to initialize the accessors for them in the Struct;
      # they are merely placeholders.
      #
      Example = Struct.new(
        *Interface.base_methods,
        keyword_init: true
      ) do
        include ComposedMethods

        alias_method :orig_strike, :strike
        def strike
          return orig_strike if equity_option?

          0
        end

        alias_method :orig_expiration_date, :expiration_date
        def expiration_date
          return orig_expiration_date if equity_option?

          Expiration::Example.new(year: 0, month: 0, day: 0)
        end
      end
    end
  end
end
