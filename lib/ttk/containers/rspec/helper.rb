require_relative "../product/shared"
require_relative "../product/example"
require_relative "../quote/shared"
require_relative "../quote/example"
require_relative "../leg/shared"
require_relative "../leg/example"
require_relative "../legs/shared"
require_relative "../legs/example"

module Helper

  # Takes year, momth, day to set the date. When given a +date+ arg, that is
  # used preferentially.
  def make_expiration(klass: TTK::Containers::Product::Expiration::Example,
                      year: nil, month: nil, day: nil, date: nil)
    if date
      year = date.year
      month = date.month
      day = date.day
    end

    klass.new(year: year, month: month, day: day)
  end

  def make_product(klass: TTK::Containers::Product::Example, symbol:, strike:, callput:, security_type:, expiration_date:)
    klass.new(symbol: symbol, strike: strike, callput: callput, security_type: security_type,
              expiration_date: make_expiration(date: expiration_date))
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
  def default_expiration(date: nil)
    date ||= Date.today + 45
    date += 1 until date.wday == 5
    date
  end

  def equity_expiration
    Date.new(1970, 1, 1)
  end

  def make_default_equity_option_product(callput: :put, strike: 155.5, expiration_date: nil)
    make_product(symbol: "AAPL",
                 strike: strike,
                 callput: callput,
                 security_type: :equity_option,
                 expiration_date: default_expiration(date: expiration_date)
    )
  end

  def make_default_equity_product
    make_product(symbol: "AAPL", strike: 0.0, callput: :none, security_type: :equity,
                 expiration_date: equity_expiration)
  end

  def make_default_equity_quote(product: nil, underlying_last: nil)
    make_equity_quote(quote_timestamp: Time.now, quote_status: :realtime, last: (underlying_last || 3.4), volume: 1234,
                      product: (product || make_default_equity_product))
  end

  def make_default_equity_option_quote(callput: :call, strike: 155.5, last: 1.4, underlying_last: 154.18,
                                       product: nil, expiration_date: nil)
    product ||= make_default_equity_option_product(callput: callput, strike: strike, expiration_date: expiration_date)

    make_equity_option_quote(quote_timestamp: Time.now,
                             quote_status: :realtime,
                             strike: strike,
                             last: last,
                             underlying_last: underlying_last,
                             volume: 1234,
                             product: product)
  end

  def make_option_leg(klass: TTK::Containers::Leg::Example, callput: :call, side: :long,
                      direction: :opening, strike: 100, last: 4.56,
                      expiration_date: nil, unfilled_quantity: 0, filled_quantity: 1,
                      price: 1.0, market_price: 0.0, stop_price: 0.0,
                      placed_time: Time.now, execution_time: Time.now, preview_time: Time.now,
                      leg_status: :executed, leg_id: 1, fees: 0.0, commission: 0.0)
    product = make_default_equity_option_product(callput: callput, strike: strike, expiration_date: expiration_date)

    quote = make_default_equity_option_quote(callput: callput, last: last, product: product, strike: strike)

    # make sure sign of quantity is corrected
    filled_quantity = side == :short ? -(filled_quantity.abs) : filled_quantity.abs

    klass.new(
      product: product,
      quote: quote,
      side: side,
      direction: direction,
      unfilled_quantity: unfilled_quantity,
      filled_quantity: filled_quantity,
      price: price,
      market_price: market_price,
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

  def make_option_order_leg(klass: TTK::Containers::Leg::Example, callput:, side:, direction:, strike:,
                      last:,
                      expiration_date: nil, unfilled_quantity: 0, filled_quantity: 1,
                      price: 1.0, market_price: 0.0, stop_price: 0.0,
                      placed_time: Time.now, execution_time: Time.now, preview_time: Time.now,
                      leg_status: :executed, leg_id: 1, fees: 0.0, commission: 0.0)
    product = make_default_equity_option_product(callput: callput, strike: strike, expiration_date: expiration_date)

    quote = make_default_equity_option_quote(callput: callput, last: last, product: product, strike: strike)
    # make sure sign of quantity is corrected
    filled_quantity = side == :short ? -(filled_quantity.abs) : filled_quantity.abs

    klass.new(
      product: product,
      quote: quote,
      side: side,
      direction: direction,
      unfilled_quantity: unfilled_quantity,
      filled_quantity: filled_quantity,
      price: price,
      market_price: market_price,
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

  def make_equity_leg(klass: TTK::Containers::Leg::Example, side:, direction:, underlying_last: 100.78,
                      unfilled_quantity: 0, filled_quantity: 1, price: 1.0, market_price: 0.0,
                      stop_price: 0.0, placed_time: Time.now, execution_time: Time.now, preview_time: Time.now,
                      leg_status: :executed, leg_id: 1, fees: 0.0, commission: 0.0)
    product = make_default_equity_product
    quote = make_default_equity_quote(product: product, underlying_last: underlying_last)
    klass.new(
      product: product,
      quote: quote,
      side: side,
      direction: direction,
      unfilled_quantity: unfilled_quantity,
      filled_quantity: filled_quantity,
      price: price,
      market_price: market_price,
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

  def make_option_position_legs(klass: TTK::Containers::Legs::Position::Example, legs: [])
    klass.new(legs: legs)
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
        value = (difference.abs / price) * 100 * (1.0 / dte)
        if value.nan?
          0
        else
          value
        end
      end

      def theta
        -(extrinsic / dte.to_f)
      end

      def intrinsic
        option_price - extrinsic
      end

      def vega
        FIXED_VEGA * dte
      end

      def gamma
        # we don't want the calc to go negative here because then
        # tests will break that expect a neg/pos result, so we bound it
        1 - [vega, 0.99].min
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
          [super, 1.0].min
        else
          [super, 0.0].max
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
          [-super, -1.0].max
        else
          [-super, 0.0].min
        end
      end
    end
  end

end
