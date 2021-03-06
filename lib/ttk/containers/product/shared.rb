# frozen_string_literal: true
require "forwardable"

require_relative 'expiration/shared'

module TTK
  module Containers
    # Defines an Equity or EquityOption product. Will some day be extended to
    # include Futures and Futures Options.
    #
    # The ComposedMethods module must be defined first. These are methods composed
    # of other required primitive methods that every subclass must implement. It"s
    # first because the Interface module maintains a list of all of the #required_methods
    # and so the order of definitions is important.
    #
    module Product
      module ComposedMethods
        def call?
          equity_option? && callput == :call
        end

        def put?
          equity_option? && callput == :put
        end

        def equity?
          security_type == :equity
        end

        def equity_option?
          security_type == :equity_option
        end

        def osi
          if equity_option?
            symbol.ljust(6, '-') +
              (expiration.year % 2000).to_s.rjust(2, '0') +
              expiration.month.to_s.rjust(2, '0') +
              expiration.day.to_s.rjust(2, '0') +
              (call? ? 'C' : 'P') +
              strike.to_i.to_s.rjust(5, '0') + ((strike - strike.to_i) * 1000).to_i.to_s.rjust(3, '0')
          else
            symbol
          end
        end

        def ==(other)
          return false unless other.respond_to?(:osi)
          osi == other.osi
        end
      end

      # All the methods that must be present on any duck-typed subclass.
      # Note that the methods in ComposedMethods are part of this list.
      #
      # We also include the required methods for Expiration which is always
      # contained inside a Product. The Product must collect and pass forward
      # the right into to initialize an Expiration instance so those values
      # need to be part of the required public interface.
      #
      module Interface
        def self.base_methods
          %i[security_type callput strike symbol expiration]
        end

        def self.required_methods
          base_methods +
            ComposedMethods.public_instance_methods
        end
      end

      module Forward
        extend Forwardable
        def_delegators :product, *Interface.required_methods
      end
    end
  end
end
