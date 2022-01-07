# frozen_string_literal: true

module TTK
  module Containers
    module Legs
      module Classifier
        # A really beautiful solution to figuring out how many combos are
        # a unit.
        #
        # Base case is simple. If a single leg has quantity 4, then it's
        # greatest common factors are 1 and 4. Therefore quantity is 4.
        #
        # If a vertical has quantities 4 and 4, then same.
        #
        # For a ratio, we may have legs with 1 and 2. Yhe gcf is 1 therefore
        # it's 1 unit. Let's say we have 3 legs with 5, 10, and 20 quantity.
        # The gcf is 5, so we have 5/5, 10/5, 20/5 +> 5 units of [1, 2, 4]
        # ratio spread.
        #
        # Cache the factor calcs so we can look them up on subsequent calls
        # without recalc.
        #
        class ComboQuantity
          def self.greatest_common_factor(quantities)
            @@cache ||= Hash.new { |h,k| h[k] = factor_calculator(k) }
            quantities.map do |quantity|
              @@cache[quantity]
            end.inject do |memo, set|
              memo & set
            end.max
          end

          def self.factor_calculator(n)
            n = n.to_i
            set = Set.new
            set << 1 << n
            n.upto(n / 2) do |i|
              set << i if (n % i).zero?
            end
            set
          end
        end
      end
    end
  end
end
