# frozen_string_literal: true

require "ttk/containers/rspec/shared_legs_spec"

RSpec.describe TTK::Containers::Legs::Position::Example do
  subject(:container) do
    described_class.from_legs(legs: legs)
  end

  describe "creation" do
    let(:legs) { [] }

    it "returns the correct class instance" do
      expect(container).to be_kind_of(described_class)
    end

    include_examples "legs interface with required methods", TTK::Containers::Legs::Position
  end

  context "where it is a 1-leg container" do
    let(:legs) { [leg] }
    let(:price) { leg.price }

    context "with a short put" do
      let(:leg) do
        make_option_leg(callput: callput, side: side, direction: direction)
      end
      let(:side) { :short }
      let(:callput) { :put }

      context "that is opening" do
        let(:direction) { :opening }

        include_examples "legs interface with short opening option"
      end
    end

    context "with a long put" do
      let(:leg) do
        make_option_leg(callput: callput, side: side, direction: direction)
      end
      let(:side) { :long }
      let(:callput) { :put }

      context "that is opening" do
        let(:direction) { :opening }

        include_examples "legs interface with long opening option"
      end
    end

    context "with short stock" do
      let(:leg) do
        make_equity_leg(side: side, direction: direction)
      end
      let(:side) { :short }

      context "that is opening" do
        let(:direction) { :opening }

        include_examples "legs interface with short opening stock"
      end
    end
  end

  context "where it is a 2-leg container" do
    let(:legs) { [leg1, leg2] }
    let(:price) { (leg1.filled_quantity * leg1.price) + (leg2.filled_quantity * leg2.price) }
    let(:strike1) { 100 }
    let(:strike2) { 90 }

    context "with a short put vertical" do
      let(:leg1) do
        make_option_leg(callput: callput, side: side1, direction: direction, strike: strike1,
                        last: 5.0)
      end
      let(:leg2) do
        make_option_leg(callput: callput, side: side2, direction: direction, strike: strike2,
                        last: 3.0) # set #last so greeks are different
      end
      let(:side1) { :short }
      let(:side2) { :long }
      let(:callput) { :put }

      context "that is opening" do
        let(:direction) { :opening }

        include_examples "legs interface with short opening vertical"
      end
    end

    context "with a long put vertical" do
      let(:leg1) do
        make_option_leg(callput: callput, side: side1, direction: direction, strike: strike1)
      end
      let(:leg2) do
        make_option_leg(callput: callput, side: side2, direction: direction, strike: strike2)
      end
      let(:side1) { :long }
      let(:side2) { :short }
      let(:callput) { :put }

      context "that is opening" do
        let(:direction) { :opening }

        include_examples "legs interface with long opening vertical"
      end
    end
  end
end

RSpec.describe TTK::Containers::Legs::Order::Example do
  subject(:container) do
    described_class.new(
      legs: legs,
      status: status,
      market_session: market_session,
      all_or_none: all_or_none,
      price_type: price_type,
      limit_price: price,
      stop_price: stop_price,
      order_term: order_term,
      order_id: order_id
    )
  end
  let(:status) { :open }
  let(:market_session) { :regular }
  let(:all_or_none) { false }
  let(:price_type) { :debit }
  let(:price) { 1.23 }
  let(:limit_price) { price } # duped for Order tests only since #limit_price has no meaning to a Position
  let(:stop_price) { 0.0 }
  let(:order_term) { :day }
  let(:order_id) { rand(999_999) }

  context "where it is a 1-leg container" do
    let(:legs) { [leg] }

    context "with a short put" do
      let(:leg) do
        make_option_leg(callput: callput, side: side, direction: direction)
      end
      let(:side) { :short }
      let(:callput) { :put }

      context "that is opening" do
        let(:direction) { :opening }

        include_examples "legs interface with short opening option"
        include_examples "legs interface - basic behavior"
        include_examples "legs interface - order behavior"
      end

      context "that is closing" do
        let(:direction) { :closing }

        include_examples "legs interface with short closing option"
        include_examples "legs interface - basic behavior"
        include_examples "legs interface - order behavior"
      end
    end

    context "with a long put" do
      let(:leg) do
        make_option_leg(callput: callput, side: side, direction: direction)
      end
      let(:side) { :long }
      let(:callput) { :put }

      context "that is opening" do
        let(:direction) { :opening }

        include_examples "legs interface with long opening option"
        include_examples "legs interface - basic behavior"
        include_examples "legs interface - order behavior"
      end

      context "that is closing" do
        let(:direction) { :closing }

        include_examples "legs interface with long closing option"
        include_examples "legs interface - basic behavior"
        include_examples "legs interface - order behavior"
      end
    end

    context "with short stock" do
      let(:leg) do
        make_equity_leg(side: side, direction: direction)
      end
      let(:side) { :short }

      context "that is opening" do
        let(:direction) { :opening }

        include_examples "legs interface with short opening stock"
        include_examples "legs interface - basic behavior"
        include_examples "legs interface - order behavior"
      end
    end
  end

  context "where it is a 2-leg container" do
    let(:legs) { [leg1, leg2] }
    let(:price) { (leg1.filled_quantity * leg1.price) + (leg2.filled_quantity * leg2.price) }
    let(:strike1) { 100 }
    let(:strike2) { 90 }

    context "with a short put vertical" do
      let(:leg1) do
        make_option_leg(callput: callput, side: side1, direction: direction, strike: strike1)
      end
      let(:leg2) do
        make_option_leg(callput: callput, side: side2, direction: direction, strike: strike2)
      end
      let(:side1) { :short }
      let(:side2) { :long }
      let(:callput) { :put }

      context "that is opening" do
        let(:direction) { :opening }

        include_examples "legs interface with short opening vertical"
        include_examples "legs interface - basic behavior"
        include_examples "legs interface - order behavior"
      end

      context "that is closing" do
        let(:direction) { :closing }

        include_examples "legs interface with short closing vertical"
        include_examples "legs interface - basic behavior"
        include_examples "legs interface - order behavior"
      end
    end

    context "with a long put vertical" do
      let(:leg1) do
        make_option_leg(callput: callput, side: side1, direction: direction, strike: strike1)
      end
      let(:leg2) do
        make_option_leg(callput: callput, side: side2, direction: direction, strike: strike2)
      end
      let(:side1) { :long }
      let(:side2) { :short }
      let(:callput) { :put }

      context "that is opening" do
        let(:direction) { :opening }

        include_examples "legs interface with long opening vertical"
        include_examples "legs interface - basic behavior"
        include_examples "legs interface - order behavior"
      end

      context "that is closing" do
        let(:direction) { :closing }

        include_examples "legs interface with long closing vertical"
        include_examples "legs interface - basic behavior"
        include_examples "legs interface - order behavior"
      end
    end
  end

  context "where it is a 4-leg container" do
    let(:legs) { [leg1, leg2, leg3, leg4] }
    let(:price) do
      (leg1.filled_quantity * leg1.price) + (leg2.filled_quantity * leg2.price) +
        (leg3.filled_quantity * leg3.price) + (leg4.filled_quantity * leg4.price)
    end
    let(:strike1) { 100 }
    let(:strike2) { 90 }
    let(:today) { Date.today }

    context "that is rolling out" do
      let(:callput) { :put }
      let(:leg1) do
        make_option_leg(callput: callput, side: side1, direction: direction1, strike: strike1,
                        expiration_date: expiration1)
      end
      let(:leg2) do
        make_option_leg(callput: callput, side: side2, direction: direction1, strike: strike2,
                        expiration_date: expiration1)
      end
      let(:leg3) do
        make_option_leg(callput: callput, side: side2, direction: direction2, strike: strike1,
                        expiration_date: expiration2)
      end
      let(:leg4) do
        make_option_leg(callput: callput, side: side1, direction: direction2, strike: strike2,
                        expiration_date: expiration2)
      end
      let(:side1) { :long }
      let(:side2) { :short }
      let(:direction1) { :closing }
      let(:direction2) { :opening }
      let(:expiration1) { today }
      let(:expiration2) { today + 45 }

      include_examples "legs interface with vertical roll out"
      include_examples "legs interface - basic behavior"
      include_examples "legs interface - order behavior"
    end

    context "that is rolling out" do
      let(:callput) { :put }
      let(:leg1) do
        make_option_leg(callput: callput, side: side1, direction: direction1, strike: strike1,
                        expiration_date: expiration1)
      end
      let(:leg2) do
        make_option_leg(callput: callput, side: side2, direction: direction1, strike: strike2,
                        expiration_date: expiration1)
      end
      let(:leg3) do
        make_option_leg(callput: callput, side: side2, direction: direction2, strike: strike1,
                        expiration_date: expiration2)
      end
      let(:leg4) do
        make_option_leg(callput: callput, side: side1, direction: direction2, strike: strike2,
                        expiration_date: expiration2)
      end
      let(:side1) { :long }
      let(:side2) { :short }
      let(:direction1) { :opening }
      let(:direction2) { :closing }
      let(:expiration1) { today }
      let(:expiration2) { today + 45 }

      include_examples "legs interface with vertical roll in"
      include_examples "legs interface - basic behavior"
      include_examples "legs interface - order behavior"
    end
  end

end
