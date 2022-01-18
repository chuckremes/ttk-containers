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
              expiration: make_expiration(date: expiration_date))
  end

  def make_equity_quote(klass: TTK::Containers::Quote::Example, quote_timestamp:, quote_status:,
                        last:, spread: 0.03, volume:, product:)
    klass.new(quote_timestamp: quote_timestamp, quote_status: quote_status, ask: last + spread, bid: last - spread,
              last: last, volume: volume, product: product)
  end

  def make_equity_option_quote(klass: TTK::Containers::Quote::Example, quote_timestamp:, quote_status:,
                               strike: 150.0, last:, underlying_last:, spread: 0.03, volume:, product:)

    dte = (product.expiration.date - Date.today).to_i
    greeks = FakeGreeks.from(underlying_last: underlying_last, strike: strike, callput: product.callput,
                             dte: dte)

    klass.new(quote_timestamp: quote_timestamp, quote_status: quote_status, ask: last + spread, bid: last - spread,
              last: last, volume: volume, product: product, dte: dte,
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
                      direction: :opening, strike: 100, last: 4.56, underlying_last: 154.18,
                      expiration_date: nil, unfilled_quantity: 0, filled_quantity: 1,
                      price: 1.0, market_price: 0.0, stop_price: 0.0,
                      placed_time: Time.now, execution_time: Time.now, preview_time: Time.now,
                      leg_status: :executed, leg_id: 1, fees: 0.0, commission: 0.0)
    product = make_default_equity_option_product(callput: callput, strike: strike, expiration_date: expiration_date)

    quote = make_default_equity_option_quote(callput: callput, last: last, product: product, strike: strike,
      underlying_last: underlying_last)

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

    def self.from(underlying_last:, strike:, callput:, dte:)
      # callput == :call ? Call.new(price: price, strike: strike, dte: dte) : Put.new(price: price, strike: strike, dte: dte)
      Options.from(price: underlying_last, strike: strike, callput: callput, dte: dte)
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

  module Options
    def self.from(price:, strike:, callput:, dte:, rfr: 0.005, volatility: 0.15)
      time_to_maturity = dte / 365.0
      cp = callput == :call ? "c" : "p"

      FakeGreeks.new(
        option_price: BlackScholes.option_price(cp, price, strike, time_to_maturity, rfr, volatility),
        delta: BlackScholes.delta(cp, price, strike, time_to_maturity, rfr, volatility),
        gamma: BlackScholes.gamma(price, strike, time_to_maturity, rfr, volatility),
        theta: BlackScholes.theta(cp, price, strike, time_to_maturity, rfr, volatility),
        vega: BlackScholes.vega(price, strike, time_to_maturity, rfr, volatility),
        rho: BlackScholes.rho(cp, price, strike, time_to_maturity, rfr, volatility),
        iv: volatility,
        callput: callput,
        strike: strike
      )
    end

    FakeGreeks = Struct.new(:option_price, :delta, :gamma, :theta, :vega, :rho,
      :iv, :callput, :strike, keyword_init: true) do
      def extrinsic

      end

      def intrinsic

      end
    end

    class BlackScholes
      # Gaussian CDF cumulative normal distribution
      #
      def self.cdf(z)
        (0.5 * (1.0 + Math.erf((z * 1.0) / 1.4142135623730951)))
      end

      def self.base_delta(stock_price, strike, time_to_maturity, risk_free_rate, volatility)
        #p stock_price, strike, time_to_maturity, risk_free_rate, volatility
        (Math.log(stock_price / strike) +
          (risk_free_rate + ((volatility * volatility) / 2.0)) * time_to_maturity) /
          (volatility * Math.sqrt(time_to_maturity))
      end

      def self.delta(callput, stock_price, strike, time_to_maturity, risk_free_rate, volatility)
        d = base_delta(stock_price, strike, time_to_maturity, risk_free_rate, volatility)

        callput == 'c' ? cdf(d) : cdf(d) - 1
      end

      # s = stock price
      # x = strike price
      # t = years to maturity
      # r = risk free rate
      # v = volatility
      #
      def self.option_price(callput, stock_price, strike, time_to_maturity, risk_free_rate, volatility)
        # d = (Log(S / K) + T * (r + 0.5 * v ^ 2)) / (v * Sqr(T))
        # BSCall = S * Gauss(d) - Exp(-r * T) * K * Gauss(d - v * Sqr(T))

        d1 = base_delta(stock_price, strike, time_to_maturity, risk_free_rate, volatility)
        d2 = d1 - (volatility * Math.sqrt(time_to_maturity))

        if callput == 'c'
          stock_price * cdf(d1) - strike * Math.exp(-(risk_free_rate * time_to_maturity)) * cdf(d2)
        else
          strike * Math.exp(-(risk_free_rate * time_to_maturity)) * cdf(-d2) - stock_price * cdf(-d1)
        end
      end

      # Given a stock price, strike, time to expiration, risk free rate,
      # dividend yield, option price, and a starting guess, we can compute
      # the implied volatility at this price and strike level.
      #
      # Implied Volatility with Newton-Raphson Iteration
      # http://investexcel.net/implied-volatility-vba/
      #
      def self.implied_volatility(callput, stock_price, strike, time_to_maturity, risk_free_rate, dividend_yield, price, guess)
        d_vol = 0.00001
        epsilon = 0.00001
        max_iterations = 100
        vol_1 = guess

        i = 0
        loop do
          value_1 = option_price(callput, stock_price, strike, time_to_maturity, risk_free_rate, vol_1)
          vol_2 = vol_1 - d_vol
          value_2 = option_price(callput, stock_price, strike, time_to_maturity, risk_free_rate, vol_2)
          dx = (value_2 - value_1) / d_vol

          break if dx.abs < epsilon || i == max_iterations

          vol_1 = vol_1 - (price - value_1) / dx
          i += 1
        end

        vol_1
      end

      def self.implied_volatility_smart_guess(callput, stock_price, strike, time_to_maturity, risk_free_rate, dividend_yield, price)
        # Expect a number between 0 and 3 as the result. Anything else and
        # it's a bad guess so try again.
        implied_vol = 0
        results = []

        (0.01...2).step(0.01) do |guess|
          implied_vol = implied_volatility(callput, stock_price, strike, time_to_maturity, risk_free_rate, dividend_yield, price, guess)

          new_price = option_price(callput, stock_price, strike, time_to_maturity, risk_free_rate, implied_vol)
          diff = (price - new_price).abs

          if diff < 0.001
            return implied_vol
          else
            # for way ITM options, the values don't converge to less than a penny
            # very easily, so we store them and choose the smallest result within
            # our range. Note that an implied vol of 3 means sentiment is looking for
            # a 300% move within the next year!
            results << implied_vol if implied_vol > 0 && implied_vol < 3
          end
        end

        # Sometimes it never converges and we don't get any results in our accepted
        # range. In that situation, make sure we return a non-nil value
        results.min || 0.001
      end

      #  Function BSGamma(S, K, T, r, v)
      #   d = (Log(S / K) + T * (r + 0.5 * v ^ 2)) / (v * Sqr(T))
      #   BSGamma = Fz(d) / S / v / Sqr(T)
      #  End Function
      def self.gamma(stock_price, strike, time_to_maturity, risk_free_rate, volatility)
        d1 = base_delta(stock_price, strike, time_to_maturity, risk_free_rate, volatility)
        pdf(d1) / stock_price / volatility / Math.sqrt(time_to_maturity)
      end

      # PDF normal distribution
      #
      def self.pdf(delta)
        #Exp(-x ^ 2 / 2) / Sqr(2 * Application.Pi())
        Math.exp((-(delta * delta)) / 2.0) / Math.sqrt(2 * Math::PI)
      end

      #  Function BSVega(S, K, T, r, v)
      #   d = (Log(S / K) + T * (r + 0.5 * v ^ 2)) / (v * Sqr(T))
      #   BSVega = S * Fz(d) * Sqr(T)
      #  End Function
      def self.vega(stock_price, strike, time_to_maturity, risk_free_rate, volatility)
        d1 = base_delta(stock_price, strike, time_to_maturity, risk_free_rate, volatility)
        stock_price * pdf(d1) * Math.sqrt(time_to_maturity)
      end

      #  Function BSRho(S, K, T, r, v, PutCall As String)
      #   d = (Log(S / K) + T * (r + 0.5 * v ^ 2)) / (v * Sqr(T))
      #   Select Case PutCall
      #    Case "Call": BSRho = T * K * Exp(-r * T) * Gauss(d - v * Sqr(T))
      #    Case "Put": BSRho = -T * K * Exp(-r * T) * Gauss(v * Sqr(T) - d)
      #   End Select
      #  End Function
      def self.rho(putcall, stock_price, strike, time_to_maturity, risk_free_rate, volatility)
        d1 = base_delta(stock_price, strike, time_to_maturity, risk_free_rate, volatility)

        if putcall == 'c'
          time_to_maturity * strike * Math.exp(-(risk_free_rate * time_to_maturity)) *
            cdf(d1 - (volatility * Math.sqrt(time_to_maturity)))
        else
          -time_to_maturity * strike * Math.exp(-(risk_free_rate * time_to_maturity)) *
            cdf((volatility * Math.sqrt(time_to_maturity)) - d1)
        end
      end

      #  Function BSTheta(S, K, T, r, v, PutCall As String)
      #   d = (Log(S / K) + T * (r + 0.5 * v ^ 2)) / (v * Sqr(T))
      #   Select Case PutCall
      #    Case "Call": BSTheta = -S * Fz(d) * v / 2 / Sqr(T) - r * K * Exp(-r * T) * Gauss(d - v * Sqr(T))
      #    Case "Put": BSTheta = -S * Fz(d) * v / 2 / Sqr(T) + r * K * Exp(-r * T) * Gauss(v * Sqr(T) - d)
      #   End Select
      #  End Function
      def self.theta(putcall, stock_price, strike, time_to_maturity, risk_free_rate, volatility)
        d1 = base_delta(stock_price, strike, time_to_maturity, risk_free_rate, volatility)

        if putcall == 'c'
          -(stock_price * pdf(d1)) * volatility / 2 / Math.sqrt(time_to_maturity) -
            risk_free_rate * strike * Math.exp(-(risk_free_rate * time_to_maturity)) *
              cdf(d1 - volatility * Math.sqrt(time_to_maturity))
        else
          -(stock_price * pdf(d1)) * volatility / 2 / Math.sqrt(time_to_maturity) +
            risk_free_rate * strike * Math.exp(-(risk_free_rate * time_to_maturity)) *
              cdf(volatility * Math.sqrt(time_to_maturity) - d1)
        end
      end
    end # BlackScholes
  end

end
