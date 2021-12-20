module TTK
  module Containers
    module Product
      module Expiration

        module ComposedMethods
          include Comparable

          def date
            @date ||= Date.new(year, month, day)
          end

          def iso8601
            @iso8601 ||= ("%04d%02d%02d" % [year, month, day])
          end

          def <=>(other)
            date <=> other.date
          end
        end

        module Interface
          def self.base_methods
            [:year, :month, :day]
          end

          def self.required_methods
            base_methods +
              ComposedMethods.public_instance_methods.reject {|m| disallowed_methods.include?(m) }
          end

          # We can"t include Comparable methods in our required list
          def self.disallowed_methods
              [:<=>, :clamp, :<=, :>=, :==, :<, :>, :between?]
          end
        end

        module Forward
          extend Forwardable
          def_delegators :expiration_date, *Interface.required_methods
        end
      end
    end
  end
end
