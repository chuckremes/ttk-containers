module Helper

  def make_expiration(klass: TTK::Containers::Product::Expiration::Example, year:, month:, day:)
    klass.new(year: year, month: month, day: day)
  end

  def make_product(klass: TTK::Containers::Product::Example, symbol:, strike:, callput:, security_type:, expiration_date:)
    klass.new(symbol: symbol, strike: strike, callput: callput, security_type: security_type, expiration_date: expiration_date)
  end

  def make_equity_quote(klass: TTK::Containers::Quote::Example, quote_timestamp:, quote_status:,
                        last:, spread: 0.03, volume:, product:)
    klass.new(quote_timestamp: quote_timestamp, quote_status: quote_status, ask: last + spread, bid: last - spread,
              last: last, volume: volume, product: product)
  end

  def make_equity_option_quote(klass: TTK::Containers::Quote::Example, quote_timestamp:, quote_status:,
                               strike: 150.0, last:, underlying_last:, spread: 0.03, volume:, product:)

    greeks = FakeGreeks.from(price: underlying_last, strike: strike, callput: product.callput,
                             dte: (product.expiration_date.date - Date.today).to_i)

    klass.new(quote_timestamp: quote_timestamp, quote_status: quote_status, ask: last + spread, bid: last - spread,
              last: last, volume: volume, product: product,
              multiplier: 100,
              open_interest: 100,
              delta: greeks.delta,
              gamma: greeks.gamma,
              theta: greeks.theta,
              vega: greeks.vega,
              rho: greeks.rho,
              iv: greeks.iv)
  end

  # Always make it around 45 DTE from today and a Friday
  def make_default_expiration
    date = Date.today + 45
    date += 1 until date.wday == 5

    make_expiration(year: date.year, month: date.month, day: date.day)
  end

  def make_equity_expiration
    make_expiration(year: 0, month: 0, day: 0)
  end

  def make_default_equity_option_product(callput: :put, strike: 155.5, expiration_date: nil)
    make_product(symbol: "AAPL",
                 strike: strike,
                 callput: callput,
                 security_type: :equity_option,
                 expiration_date: (expiration_date || make_default_expiration)
    )
  end

  def make_default_equity_product
    make_product(symbol: "AAPL", strike: 0.0, callput: :none, security_type: :equity, expiration_date: make_equity_expiration)
  end

  def make_default_equity_quote
    make_equity_quote(quote_timestamp: Time.now, quote_status: :realtime, ask: 3.44, bid: 3.39, last: 3.4, volume: 1234,
                      product: make_default_equity_product)
  end

  def make_default_equity_option_quote(callput: :call, strike: 155.5, last: 1.4, underlying_last: 154.18, product: nil, expiration_date: nil)
    product ||= make_default_equity_option_product(callput: callput, strike: strike, expiration_date: expiration_date)

    make_equity_option_quote(quote_timestamp: Time.now,
                             quote_status: :realtime,
                             last: last,
                             underlying_last: underlying_last,
                             volume: 1234,
                             product: product)
  end

  def make_option_leg(klass: TTK::Containers::Leg::Example, callput:, side:, direction:, strike:,
                      last:, underlying_last:,
                      expiration_date: nil, unfilled_quantity: 0, filled_quantity: 1,
                      execution_price: 1.0, order_price: 0.0, stop_price: 0.0,
                      placed_time: Time.now, execution_time: Time.now, preview_time: Time.now,
                      leg_status: :executed, leg_id: 1, fees: 0.0, commission: 0.0)
    product = make_default_equity_option_product(callput: callput, strike: strike, expiration_date: expiration_date)

    quote = make_default_equity_option_quote(callput: callput, last: last, product: product)

    klass.new(
      product: product,
      side: side,
      direction: direction,
      unfilled_quantity: unfilled_quantity,
      filled_quantity: filled_quantity,
      execution_price: execution_price,
      order_price: order_price,
      placed_time: placed_time,
      execution_time: execution_time,
      preview_time: preview_time,
      leg_status: leg_status,
      leg_id: leg_id,
      stop_price: stop_price,
      fees: fees,
      commission: commission
    )
  end

  # option price = dte * delta
  # closer to strike means closer to 50 delta; every 1% above/below changes
  # delta by same (difference / price) * 100 * (1/dte)
  # theta is extrinsic / dte
  # extrinsic is (option price - strike) * delta
  # intrinsic is option price - extrinsic
  # vega is (dte * FIXED_VEGA), it gets smaller as dte goes to 0
  # gamma is (1 - vega) so it gets bigger as dte goes to 0
  class FakeGreeks
    FIXED_VEGA = 0.02

    def self.from(price:, strike:, callput:, dte:)
      callput == :call ? Call.new(price: price, strike: strike, dte: dte) : Put.new(price: price, strike: strike, dte: dte)
    end

    def self.equity
      from(price: 0, strike: 0, callput: :call, dte: 0)
    end

    class Base
      attr_reader :price, :dte, :strike

      def initialize(price:, strike:, dte:)
        @price = price.to_f
        @dte = dte.to_f
        @strike = strike.to_f
        @change = difference / price.to_f
      end

      def option_price
        dte * delta.abs
      end

      def delta
        value = (difference.abs / price) * 100 * (1 / dte)
        if value.nan?
          0
        else
          value
        end
      end

      def theta
        -(extrinsic / dte)
      end

      def intrinsic
        option_price - extrinsic
      end

      def vega
        FIXED_VEGA * dte
      end

      def gamma
        1 - vega
      end

      def rho
        0.001
      end

      def iv
        value = @change + 0.1
        value = value.nan? ? 0.1 : value
        [value, 3.5].min
      end

      def itm?
        difference.negative?
      end
    end

    class Call < Base
      def difference
        # always assume OTM so difference is positive
        # when negative then ITM
        strike - price
      end

      def extrinsic
        if itm?
          1 - (1 / dte)
        else
          difference.abs * delta.abs
        end
      end

      def delta
        # handle overflows
        if itm?
          [0.5 + super, 1.0].min
        else
          [0.5 - super, 0.0].max
        end
      end
    end

    class Put < Base
      def difference
        price - strike
      end

      def extrinsic
        if itm?
          1 - (1 / dte)
        else
          difference.abs * delta.abs
        end
      end

      def delta
        # handle overflows
        if itm?
          [-0.5 - super, -1.0].max
        else
          [-0.5 + super, 0.0].min
        end
      end
    end
  end

end
