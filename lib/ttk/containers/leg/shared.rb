
module TTK
  module Containers
    module Leg

      # Any concrete implementation of a Leg class from a vendor must provide
      # these elemental methods. The Leg::ComposedMethods methods will use some
      # of these too.
      module Interface
        def self.required_methods
          [
            :symbol,
            :expiration_date,
            :strike,
            :callput,
            :security_type,
            :quote,
            :side,
            :unfilled_quantity,
            :filled_quantity,
            :limit_price,
            :order_term,
            :placed_time,
            :execution_time,
            :leg_status,
            :identity,
            :price_type
          ]
        end
      end

      # The basic logic associated with any Leg Container. All leg containers must
      # implement the interface as defined in interface.rb. That concrete implementation
      # includes this shared module to round out the details
      module ComposedMethods
        def call?
          :call == callput
        end

        def put?
          :put == callput
        end

        def equity?
          :equity == security_type
        end

        def equity_option?
          :equity_option == security_type
        end

        def osi
          if equity_option?
            symbol.ljust(6, '-') +
              (expiration_date.year % 2000).to_s.rjust(2, '0') +
              expiration_date.month.to_s.rjust(2, '0') +
              expiration_date.day.to_s.rjust(2, '0') +
              (call? ? 'C' : 'P') +
              strike.to_i.to_s.rjust(5, '0') + ((strike - strike.to_i) * 1000).to_i.to_s.rjust(3, '0')
          else
            symbol
          end
        end

        def to_product
          h = {
            'symbol'       => symbol,
            'securityType' => security_type
          }

          if equity_option?
            h.merge(
              'callPut'     => callput,
              'expiryYear'  => expiration_date.year.to_s,
              'expiryMonth' => expiration_date.month.to_s.rjust(2, '0'),
              'expiryDay'   => expiration_date.day.to_s.rjust(2, '0'),
              'strikePrice' => strike.to_s
            )
          else
            h
          end
        end
      end

    end
  end
end
