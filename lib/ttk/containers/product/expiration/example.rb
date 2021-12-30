# frozen_string_literal: true

module TTK
  module Containers
    module Product
      module Expiration
        Example = Struct.new(*Interface.base_methods,
                             keyword_init: true) do
          include ComposedMethods

          def year
            return dig(:year) if dig(:year) > 0
            1970
          end

          def month
            return dig(:month) if dig(:month).between?(1, 12)
            1
          end

          def day
            return dig(:day) if dig(:day).between?(1, 31)
            1
          end
        end
      end
    end
  end
end
