require "ttk/containers/rspec/shared_leg_spec"

RSpec.describe TTK::Containers::Leg::Example do

  subject(:container) do
    described_class.new(quote: quote,
                        product: product
    )
  end

  describe "creation" do
    # it "returns a Leg instance" do
    #   expect(container).to be_instance_of(described_class)
    # end
    #
    # include_examples "leg interface - required methods", TTK::Containers::Leg
  end

  context 'position leg' do

  end

  context 'order leg' do

  end
end
