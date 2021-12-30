# frozen_string_literal: true

require 'ttk/containers/rspec/shared_product_spec'

RSpec.describe TTK::Containers::Product::Example do
  let(:symbol) { "AAPL" }
  let(:symbol2) { 'FB' }
  let(:strike) { 155 }
  let(:callput) { :call }
  let(:security_type) { :equity_option }
  let(:year) { 2022 }
  let(:month) { 2 }
  let(:day) { 18 }

  subject(:container) do
    expiration = make_expiration(year: year, month: month, day: day)
    make_product(klass: described_class, symbol: symbol, strike: strike, callput: callput,
                 security_type: security_type, expiration_date: expiration)
  end

  let(:different_container) do
    expiration = make_expiration(year: year, month: month, day: day + 1)
    make_product(klass: described_class, symbol: symbol2, strike: strike, callput: callput,
                 security_type: security_type, expiration_date: expiration)
  end

  describe 'creation' do
    it 'returns a product instance' do
      expect(container).to be_instance_of(described_class)
    end

    include_examples 'product interface with required methods', TTK::Containers::Product
  end

  # Must use #it_behaves_like with its nested context to avoid the #let overrides
  # from happening; see docs
  it_behaves_like "product interface with basic call option behaviors"
  it_behaves_like "product interface with basic put option behaviors"
  it_behaves_like "product interface with basic equity instrument behaviors"
end
