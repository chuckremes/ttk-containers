require "ttk/containers/rspec/shared_leg_spec"

RSpec.describe TTK::Containers::Leg::Example do
  let(:quote) { make_default_equity_option_quote(callput: :put) }
  let(:product) { quote.product }

  let(:leg_id) { 123 }
  let(:leg_status) { :open }
  let(:fees) { 1.23 }
  let(:commission) { 2.34 }
  let(:side) { :long }
  let(:unfilled_quantity) { 0 }
  let(:filled_quantity) { 0 }
  let(:price) { 5.21 }
  let(:market_price) { 0.0 }
  let(:stop_price) { 0.0 }
  let(:now) { Time.now }
  let(:placed_time) { TTK::Containers::Leg::EPOCH }
  let(:execution_time) { TTK::Containers::Leg::EPOCH }
  let(:preview_time) { TTK::Containers::Leg::EPOCH }
  let(:direction) { :opening }

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
                        price: price,
                        market_price: market_price,
                        stop_price: stop_price,
                        placed_time: placed_time,
                        execution_time: execution_time,
                        preview_time: preview_time,
                        direction: direction)
  end

  describe "creation" do
    it "returns a Leg instance" do
      expect(container).to be_instance_of(described_class)
    end

    include_examples "leg interface with required methods", TTK::Containers::Leg
  end

  context "position leg" do
    let(:execution_time) { Time.new(now.year, now.month, now.day, 0, 0, 0, TTK::Eastern_TZ) }

    context "with a call position" do
      let(:quote) { make_default_equity_option_quote(callput: :call) }

      context "and where it is short then" do
        let(:side) { :short }
        let(:filled_quantity) { -2 }

        include_examples "leg interface - short position"
        include_examples "leg interface - short call greeks"
      end

      context "and where it is long then" do
        let(:side) { :long }
        let(:filled_quantity) { 1 }

        include_examples "leg interface - long position"
        include_examples "leg interface - long call greeks"
      end
    end

    context "with a put position" do
      context "and where it is short then" do
        let(:quote) { make_default_equity_option_quote(callput: :put) }
        let(:side) { :short }
        let(:filled_quantity) { -2 }

        include_examples "leg interface - short position"
        include_examples "leg interface - short put greeks"
      end

      context "and where it is long then" do
        let(:quote) { make_default_equity_option_quote(callput: :put) }
        let(:side) { :long }
        let(:filled_quantity) { 1 }

        include_examples "leg interface - long position"
        include_examples "leg interface - long put greeks"
      end
    end

    context "with an equity position" do
      context "and where it is short then" do
        let(:quote) { make_default_equity_quote }
        let(:side) { :short }
        let(:filled_quantity) { -200 }

        include_examples "leg interface - short position"
      end

      context "and where it is long then" do
        let(:quote) { make_default_equity_quote }
        let(:side) { :long }
        let(:filled_quantity) { 200 }

        include_examples "leg interface - long position"
      end
    end

    include_examples "leg interface basic position behavior"
  end

  context "order leg" do
    let(:execution_time) { Time.new(now.year, now.month, now.day, 0, 0, 0, TTK::Eastern_TZ) }

    context "with a short call then" do
      let(:quote) { make_default_equity_option_quote(callput: :call) }
      let(:side) { :short }
      let(:unfilled_quantity) { 2 }

      include_examples "leg interface - short order"
      include_examples "leg interface - short call greeks"
    end

    context "with a short put then" do
      let(:quote) { make_default_equity_option_quote(callput: :put) }
      let(:side) { :short }
      let(:unfilled_quantity) { 2 }

      include_examples "leg interface - short order"
      include_examples "leg interface - short put greeks"
    end

    context "with a long call then" do
      let(:quote) { make_default_equity_option_quote(callput: :call) }
      let(:side) { :long }
      let(:unfilled_quantity) { 1 }

      include_examples "leg interface - long order"
      include_examples "leg interface - long call greeks"
    end

    context "with a long put then" do
      let(:quote) { make_default_equity_option_quote(callput: :put) }
      let(:side) { :long }
      let(:unfilled_quantity) { 1 }

      include_examples "leg interface - long order"
      include_examples "leg interface - long put greeks"
    end

    include_examples "leg interface basic order behavior"
  end
end
