module TTK
  module Containers
    module Quotes
      module Quote

        # Public methods that every class that defines the Interface should also expose.
        # These methods are defined in terms of that Interface definition, so we
        # provide them here rather than reinventing them for every concrete class.
        module ComposedMethods
          def midpoint
            ((ask.to_f + bid.to_f) / 2.0).round(half: :down)
          end

          def nice_print
            separator = ' | '
            puts "QuoteTS".rjust(21).ljust(22) + separator +
                   "Bid".rjust(6).ljust(7) + separator +
                   "Ask".rjust(6).ljust(7) + separator +
                   "Last".rjust(6).ljust(7) + separator
            now  = self.quote_timestamp.strftime("%Y%m%d-%H:%M:%S.%L").rjust(21).ljust(22)
            b    = self.bid.to_s.rjust(6).ljust(7)
            a    = self.ask.to_s.rjust(6).ljust(7)
            last = self.last.to_s.rjust(6).ljust(7)
            puts [now, bid, ask, last].join(separator)
          end
        end

        # Defines the required methods that any implementation of a quote should provide.
        # This allows for consistency across TTK vendors. As long as the vendor implementation
        # provides a Quote class that conforms to this interface then the consumers of these
        # classes will Just Work. Duck typing!
        module Interface
          def self.base_methods
            [:quote_timestamp, :quote_status, :ask, :bid, :last, :volume, :dte, :open_interest,
             :intrinsic, :extrinsic, :multiplier, :delta, :theta, :gamma, :vega, :rho, :iv]
          end

          def self.required_methods
            base_methods +
              ComposedMethods.public_instance_methods
          end
        end

        # Included by concrete classes that want to expose a Quote interface
        # for outside consumption. References Interface.required_methods directly
        # in forwarding so that the lists never fall out of sync.
        #
        # Example: would be included in a Leg class that contains a quote so that
        # all the quote methods are auto-forwarded to Leg#quote.
        module Forward
          extend Forwardable
          def_delegators :quote, *Interface.required_methods
        end

      end

    end
  end
end
