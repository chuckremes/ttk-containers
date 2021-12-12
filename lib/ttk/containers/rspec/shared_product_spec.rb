
RSpec.shared_examples "product interface" do |product_class, parent_module|
  subject(:product) do
    expiration = parent_module::Expiration::Example.new(year: year, month: month, day: day)
    product_class.new(symbol:        symbol,
                        strike:        strike,
                        callput:       callput,
                        security_type: security_type,
                      expiration_date: expiration
    )
  end

  let(:symbol) { 'SPY' }
  let(:strike) { 50 }
  let(:callput) { :call }
  let(:security_type) { :equity_option }
  let(:year) { 2021 }
  let(:month) { 12 }
  let(:day) { 11 }

  it 'conforms to the required interface' do
    TTK::Containers::Product::Interface.required_methods.each do |rm|
      expect(product).to respond_to(rm)
    end
  end

  context 'call option' do
    subject { product.call? }
    let(:callput) { :call }

    describe '#call?' do
      it 'returns true' do
        expect(subject).to be true
      end
    end

  end
end
