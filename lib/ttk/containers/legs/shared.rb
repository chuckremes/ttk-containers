# frozen_string_literal: true
require_relative 'classifier/action'

module TTK
  module Containers
    module Legs

      module Shared
        module Interface
          def self.base_methods
            %i[ legs status ]
          end

          def self.required_methods
            m = base_methods +
              ComposedMethods.public_instance_methods

            m.uniq.reject { |m| disallowed_methods.include?(m) }
          end

          # We can"t include Comparable methods in our required list
          def self.disallowed_methods
            %i[<=> clamp <= >= == < > between?]
          end

        end

        # The basic logic associated with any Leg Container. All leg containers must
        # implement the interface as defined in interface.rb. That concrete implementation
        # includes this shared module to round out the details
        module ComposedMethods

          def leg_count
            legs.count
          end

          def all?(field:)
            legs.all? { |leg| leg.send(field) }
          end

          def any?(field)
            legs.any? { |leg| leg.send(field) }
          end

          def map(field:)
            legs.map { |leg| leg.send(field) }
          end

          def ==(other)
            # assumes legs are sorted consistently
            legs.count == other.legs.count && legs.zip(other.legs).all? do |l1, l2|
              l1 == l2
            end
          end

          def put?
            all?(:put?)
          end

          def call?
            all?(:call?)
          end

          def equity?
            all?(:equity?)
          end

          def equity_option?
            all?(:equity_option?)
          end

          def opening?
            any?(:opening?)
          end

          def closing?
            any?(:closing?)
          end

          def short?
            all?(:short?)
          end

          def long?
            all?(:long?)
          end

          def roll?
            any?(:short?) && any?(:long?)
          end

          def open?
            status == :open
          end

          def active?
            # :new is defined for an order we haven't downloaded yet
            %i[new open cancel_requested partial individual_fills].include?(status)
          end

          def inactive?
            !active?
          end

          def symbol
            s = map(field: :symbol).uniq
            raise MultipleSymbolError, s.inspect if s.size > 1

            s
          end

          def fees
            summation(:fees)
          end

          def commission
            summation(:commission)
          end

          # Greeks!

          def delta
            summation(field: :delta)
          end

          def gamma
            summation(field: :gamma)
          end

          def theta
            summation(field: :theta)
          end

          def vega
            summation(field: :vega)
          end

          def rho
            summation(field: :rho)
          end

          def summation(field:)
            legs.inject(0.0) { |memo, leg| memo + leg.send(field).to_f }
          end
        end
      end

      module Position
        module Interface
          def self.base_methods
            Shared.base_methods
          end

          def self.required_methods
            m = base_methods +
              ComposedMethods.public_instance_methods

            m.uniq.reject { |m| disallowed_methods.include?(m) }
          end

          # We can"t include Comparable methods in our required list
          def self.disallowed_methods
            %i[<=> clamp <= >= == < > between?]
          end
        end

        module ComposedMethods
          MultipleSymbolError = Class.new(StandardError)

          def rolling?
            # only makes sense in the context of an Order
            # a Position would, by definition, never see the closing leg because it is CLOSED
            opening? && closing?
          end

          # Very important. We can infer the action from the contents of the legs.
          #
          # Leg Count:
          #   1
          def action
            Classifier::Action.classify(legs)
          end
        end

        module ClassMethods
          def from_legs(legs:, status:)
            # sigh, ruby doesn't have a stable sort so we need to rely on this index hack,
            # see here for details:
            # https://medium.com/store2be-tech/stable-vs-unstable-sorting-2943b1d13977
            legs = if legs.all? { |l| l.put? }
                     legs.sort_by.with_index { |leg, i| [-leg.strike, i] }
                         .sort_by.with_index { |leg, i| [leg.expiration_date.date, i] }
                   else
                     legs.sort_by.with_index { |leg, i| [leg.strike, i] }
                         .sort_by.with_index { |leg, i| [leg.expiration_date.date, i] }
                   end

            new(legs: legs, status: status)
          end
        end


        module Order
          module Interface
            def self.base_methods
              Shared.base_methods +
                %i[ market_session all_or_none price_type limit_price stop_price order_term ]
            end

            def self.required_methods
              m = base_methods +
                Shared::ComposedMethods.public_instance_methods +
                ComposedMethods.public_instance_methods

              m.uniq.reject { |m| disallowed_methods.include?(m) }
            end

            # We can"t include Comparable methods in our required list
            def self.disallowed_methods
              %i[<=> clamp <= >= == < > between?]
            end
          end

          module ComposedMethods
            MultipleSymbolError = Class.new(StandardError)

            def rolling?
              # only makes sense in the context of an Order
              # a Position would, by definition, never see the closing leg because it is CLOSED
              opening? && closing?
            end

            # Very important. We can infer the order_type from the contents of the legs.
            #
            def order_type
              Classifier::Combo.classify(legs)
            end
          end

          module ClassMethods
            def from_legs(legs:, status:)
              # sigh, ruby doesn't have a stable sort so we need to rely on this index hack,
              # see here for details:
              # https://medium.com/store2be-tech/stable-vs-unstable-sorting-2943b1d13977
              legs = if legs.all? { |l| l.put? }
                       legs.sort_by.with_index { |leg, i| [-leg.strike, i] }
                           .sort_by.with_index { |leg, i| [leg.expiration_date.date, i] }
                     else
                       legs.sort_by.with_index { |leg, i| [leg.strike, i] }
                           .sort_by.with_index { |leg, i| [leg.expiration_date.date, i] }
                     end

              new(legs: legs, status: status)
            end
          end
      end
    end
  end
end
