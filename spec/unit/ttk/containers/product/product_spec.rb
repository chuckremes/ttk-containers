# frozen_string_literal: true

require 'ttk/containers/rspec/shared_product_spec'

RSpec.describe TTK::Containers::Product::Example do
  let(:symbol) { 'SPY' }
  let(:symbol2) { 'FB' }
  let(:strike) { 50 }
  let(:callput) { :call }
  let(:security_type) { :equity_option }
  let(:year) { 2021 }
  let(:month) { 12 }
  let(:day) { 11 }

  subject(:container) do
    expiration = make_expiration(year: year, month: month, day: day)
    make_product(klass: described_class, symbol: symbol, strike: strike, callput: callput,
                 security_type: security_type, expiration_date: expiration)
  end

  let(:exact_duplicate) do
    expiration = make_expiration(year: year, month: month, day: day)
    make_product(klass: described_class, symbol: symbol, strike: strike, callput: callput,
                 security_type: security_type, expiration_date: expiration)
  end

  let(:different_duplicate) do
    expiration = make_expiration(year: year, month: month, day: day + 1)
    make_product(klass: described_class, symbol: symbol2, strike: strike, callput: callput,
                 security_type: security_type, expiration_date: expiration)
  end

  describe 'creation' do
    it 'returns a product instance' do
      expect(container).to be_instance_of(described_class)
    end

    include_examples 'product interface - required methods', TTK::Containers::Product
  end

  describe 'call option' do
    let(:callput) { :call }

    include_examples 'product interface - call'
  end

  describe 'put option' do
    let(:callput) { :put }

    include_examples 'product interface - put'
  end

  describe 'equity' do
    let(:security_type) { :equity }

    include_examples 'product interface - equity'
  end
end
