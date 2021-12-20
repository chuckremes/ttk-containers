module Helper

  def make_expiration(klass: TTK::Containers::Product::Expiration::Example, year:, month:, day:)
    klass.new(year: year, month: month, day: day)
  end

  def make_product(klass: TTK::Containers::Product::Example, symbol:, strike:, callput:, security_type:, expiration_date:)
    klass.new(symbol: symbol, strike: strike, callput: callput, security_type: security_type, expiration_date: expiration_date)
  end

  def make_equity_quote(klass: TTK::Containers::Quote::Example, quote_timestamp:, quote_status:, ask:, bid:,
                        last:, volume:, product:)
    klass.new(quote_timestamp: quote_timestamp, quote_status: quote_status, ask: ask, bid: bid, last: last, volume: volume, product: product)
  end

  def make_equity_option_quote(klass: TTK::Containers::Quote::Example, quote_timestamp:, quote_status:, ask:, bid:, last:, volume:,
                               product:)
    klass.new(quote_timestamp: quote_timestamp, quote_status: quote_status, ask: ask, bid: bid, last: last, volume: volume, product: product)
  end

  # Always make it around 45 DTE from today and a Friday
  def make_default_expiration
    date = Date.today + 45
    date += 1 until date.wday == 5

    make_expiration(year: date.year, month: date.month, day: date.day)
  end

  def make_equity_expiration
    make_expiration(year:0, month: 0, day: 0)
  end

  def make_default_equity_option_product
    make_product(symbol: "AAPL", strike: 155.5, callput: :put, security_type: :equity_option, expiration_date: make_default_expiration)
  end

  def make_default_equity_product
    make_product(symbol: "AAPL", strike: 0.0, callput: :none, security_type: :equity, expiration_date: make_equity_expiration)
  end

  def make_default_equity_quote
    make_equity_quote(quote_timestamp: Time.now, quote_status: :realtime, ask: 3.44, bid: 3.39, last: 3.4, volume: 1234,
                      product: make_default_equity_product)
  end

  def make_default_equity_option_quote
    make_equity_option_quote(quote_timestamp: Time.now, quote_status: :realtime, ask: 3.44, bid: 3.39, last: 3.4, volume: 1234,
                             product: make_default_equity_option_product)

  end
end
