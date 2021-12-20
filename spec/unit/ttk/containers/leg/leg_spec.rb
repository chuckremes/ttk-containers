require "ttk/containers/rspec/shared_leg_spec"

RSpec.describe TTK::Containers::Leg::Example do

  let(:quote) { make_default_equity_option_quote }
  let(:product) { quote.product }
  let(:leg_id) { 123 }
  let(:leg_status) { :open }
  let(:fees) { 1.23 }
  let(:commission) { 2.34 }
  let(:side) { :long }
  let(:unfilled_quantity) { 0 }
  let(:filled_quantity) { 0 }
  let(:execution_price) { 5.21 }
  let(:order_price) { 0.0 }
  let(:stop_price) { 0.0 }
  let(:now) { Time.now }
  let(:placed_time) { TTK::Containers::Leg::EPOCH }
  let(:execution_time) { TTK::Containers::Leg::EPOCH }
  let(:preview_time) { TTK::Containers::Leg::EPOCH }

  subject(:container) do
    described_class.new(quote: quote,
                        product: product,
                        leg_id: leg_id,
                        leg_status: leg_status,
                        fees: fees,
                        commission: commission,
                        side: side,
                        unfilled_quantity: unfilled_quantity,
                        filled_quantity: filled_quantity,
                        execution_price: execution_price,
                        order_price: order_price,
                        stop_price: stop_price,
                        placed_time: placed_time,
                        execution_time: execution_time,
                        preview_time: preview_time
    )
  end

  describe "creation" do
    it "returns a Leg instance" do
      expect(container).to be_instance_of(described_class)
    end

    include_examples "leg interface - required methods", TTK::Containers::Leg
  end

  context 'position leg' do
    let(:execution_price) { 5.21 }
    let(:order_price) { 0.0 }
    let(:stop_price) { 0.0 }
    let(:now) { Time.now }
    let(:placed_time) { TTK::Containers::Leg::EPOCH }
    let(:execution_time) { Time.new(now.year, now.month, now.day, 0, 0, 0, Eastern_TZ) }
    let(:preview_time) { TTK::Containers::Leg::EPOCH }

    context 'where it is short' do
      let(:side) { :short }
      let(:unfilled_quantity) { 0 }
      let(:filled_quantity) { -2 }

      include_examples 'leg interface - short position'
    end

    context 'where it is long' do
      let(:side) { :long }
      let(:unfilled_quantity) { 0 }
      let(:filled_quantity) { 1 }

      include_examples 'leg interface - long position'
    end

    include_examples 'leg interface - basic behavior'
  end

  context 'order leg' do
    let(:execution_price) { 5.21 }
    let(:order_price) { 0.0 }
    let(:stop_price) { 0.0 }
    let(:now) { Time.now }
    let(:placed_time) { TTK::Containers::Leg::EPOCH }
    let(:execution_time) { Time.new(now.year, now.month, now.day, 0, 0, 0, Eastern_TZ) }
    let(:preview_time) { TTK::Containers::Leg::EPOCH }

    context 'where it is short' do
      let(:side) { :short }
      let(:unfilled_quantity) { 2 }
      let(:filled_quantity) { 0 }

      include_examples 'leg interface - short order'
    end

    context 'where it is long' do
      let(:side) { :long }
      let(:unfilled_quantity) { 1 }
      let(:filled_quantity) { 0 }

      include_examples 'leg interface - long order'
    end

    include_examples 'leg interface - basic behavior'
  end
end
