require 'ttk/containers/rspec/shared_product_spec'

RSpec.describe TTK::Containers::Product::Example do

  describe 'creation' do
    subject(:product) do
      described_class.new(symbol:        symbol,
                          strike:        strike,
                          callput:       callput,
                          security_type: security_type,
                          year:          year,
                          month:         month,
                          day:           day
      )
    end

    let(:symbol) { 'SPY' }
    let(:strike) { 50 }
    let(:callput) { :call }
    let(:security_type) { :option }
    let(:year) { 2021 }
    let(:month) { 12 }
    let(:day) { 11 }

    it 'returns a product' do
      expect(product).to be_instance_of(described_class)
    end

    include_examples 'product interface', described_class, TTK::Containers::Product
  end
end
