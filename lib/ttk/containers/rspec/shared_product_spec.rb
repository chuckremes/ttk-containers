require_relative 'shared_expiration_spec'

RSpec.shared_examples "product interface - required methods" do |parent_module|

  it 'conforms to the required interface' do
    parent_module::Interface.required_methods.each do |rm|
      expect(product).to respond_to(rm)
    end
  end

end

RSpec.shared_examples 'product interface - call' do
  describe '#call?' do
    it 'returns true' do
      expect(product.call?).to be true
    end
  end

  describe '#put?' do
    it 'returns false' do
      expect(product.put?).to be false
    end
  end

  describe '#equity_option?' do
    it 'returns true' do
      expect(product.equity_option?).to be true
    end
  end

  describe '#equity?' do
    it 'returns false' do
      expect(product.equity?).to be false
    end
  end

  describe '#strike' do
    it 'returns the strike' do
      expect(product.strike).to eq strike
    end
  end

  describe '#expiration_date' do
    let(:expiration) { product.expiration_date }

    include_examples 'expiration interface - year'
    include_examples 'expiration interface - month'
    include_examples 'expiration interface - day'
  end
end