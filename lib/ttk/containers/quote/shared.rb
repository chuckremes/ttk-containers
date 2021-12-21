# frozen_string_literal: true

module TTK
  module Containers
    module Quote
      module ComposedMethods
        def midpoint
          if bid.positive? || ask.positive?
            ((bid.to_f + ask.to_f) / 2.0).round(2, half: :down)
          else
            # handles case where it's a non-trading index, e.g. VIX
            last
          end
        end

        def nice_print_header
          separator = '|'

          [
            separator,
            ['QuoteTS'.rjust(21).ljust(22) + separator +
              'Bid'.rjust(6).ljust(7) + separator +
              'Ask'.rjust(6).ljust(7) + separator +
              'Last'.rjust(6).ljust(7) + separator +
              'delta'.rjust(6).ljust(7) + separator +
              'gamma'.rjust(6).ljust(7) + separator +
              'theta'.rjust(6).ljust(7) + separator +
              'iv'.rjust(6).ljust(7)].join(separator)
          ]
        end

        def nice_print
          separator, header_string = nice_print_header
          puts header_string

          now = quote_timestamp.strftime('%Y%m%d-%H:%M:%S.%L').rjust(21).ljust(22)
          bid = self.bid.to_s.rjust(6).ljust(7)
          ask = self.ask.to_s.rjust(6).ljust(7)
          last = self.last.to_s.rjust(6).ljust(7)
          delta = self.delta.rjust(6).ljust(7)
          gamma = self.gamma.rjust(6).ljust(7)
          theta = self.theta.rjust(6).ljust(7)
          iv = self.iv.rjust(6).ljust(7)
          puts [now, bid, ask, last, delta, gamma, theta, iv].join(separator)
        end
      end

      module Interface
        def self.base_methods
          %i[quote_timestamp quote_status ask bid last volume product update_quote
             dte open_interest intrinsic extrinsic
             multiplier delta theta gamma vega rho iv]
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
