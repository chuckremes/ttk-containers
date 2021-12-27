$: << File.expand_path(File.join(__dir__, "..", "..", "..")) # useful when this file is directly required by other gems
require_relative "shared_product_spec"
require_relative "shared_quote_spec"

RSpec.shared_examples "legs interface - required methods" do |parent_module|
  parent_module::Interface.required_methods.each do |rm|
    it "conforms to the expected interface by responding to method #{rm}" do
      expect(container).to respond_to(rm)
    end
  end

  # include_examples "product interface - required methods", TTK::Containers::Product
  # include_examples "quote interface - required methods", TTK::Containers::Quote
end

RSpec.shared_examples 'legs interface - 4-leg order roll out' do
  describe '#opening' do
    it 'returns true' do
      expect(container.opening?).to eq true
    end
  end

  describe '#closing' do
    it 'returns true' do
      expect(container.closing?).to eq true
    end
  end

  describe '#rolling' do
    it 'returns true' do
      expect(container.rolling?).to eq true
    end
  end

  describe '#action' do
    it 'returns :roll_out' do
      expect(container.action).to eq :roll_out
    end
  end

  describe '#order_type' do
    it 'returns :spread_diagonal_roll' do
      expect(container.order_type).to eq :spread_diagonal_roll
    end
  end
end

RSpec.shared_examples 'legs interface - 4-leg order roll in' do

  describe '#opening' do
    it 'returns true' do
      expect(container.opening?).to eq true
    end
  end

  describe '#closing' do
    it 'returns true' do
      expect(container.closing?).to eq true
    end
  end

  describe '#rolling' do
    it 'returns true' do
      expect(container.rolling?).to eq true
    end
  end

  describe '#action' do
    it 'returns :roll_in' do
      expect(container.action).to eq :roll_in
    end
  end

  describe '#order_type' do
    it 'returns :spread_diagonal_roll' do
      expect(container.order_type).to eq :spread_diagonal_roll
    end
  end

end