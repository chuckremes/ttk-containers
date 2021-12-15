require 'ttk/containers/rspec/shared_expiration_spec'

RSpec.describe TTK::Containers::Product::Expiration::Example do
  let(:year) { 2021 }
  let(:month) { 12 }
  let(:day) { 11 }

  subject(:expiration) do
    described_class.new(year: year, month: month, day: day)
  end

  describe 'creation' do
    it 'returns an expiration instance' do
      expect(expiration).to be_instance_of(described_class)
    end

    include_examples 'expiration interface - required methods', TTK::Containers::Product::Expiration
  end

  describe '#year' do
    include_examples 'expiration interface - year'
  end

  describe '#month' do
    include_examples 'expiration interface - month'
  end

  describe '#day' do
    include_examples 'expiration interface - day'
  end
end
