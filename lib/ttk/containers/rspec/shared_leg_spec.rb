# frozen_string_literal: true

$LOAD_PATH << File.expand_path(File.join(__dir__, "..", "..", "..")) # useful when this file is directly required by other gems
require_relative "shared_product_spec"
require_relative "shared_quote_spec"

RSpec.shared_examples "leg interface with required methods" do |parent_module|
  parent_module::Interface.required_methods.each do |rm|
    it "implements expected interface method :#{rm}" do
      expect(container).to respond_to(rm)
    end
  end

  include_examples "product interface with required methods", TTK::Containers::Product
  include_examples "quote interface with required methods", TTK::Containers::Quote

  # Type check...

  describe "#unfilled_quantity" do
    it "returns a Numeric" do
      expect(container.unfilled_quantity).to be_kind_of(Numeric)
    end
  end

  describe "#filled_quantity" do
    it "returns a Numeric" do
      expect(container.filled_quantity).to be_kind_of(Numeric)
    end
  end

  describe "#side" do
    it "returns a Symbol" do
      expect(container.side).to be_kind_of(Symbol)
    end
  end

  describe "#execution_time" do
    it "returns a Time" do
      expect(container.execution_time).to be_kind_of(Time)
    end
  end

  describe "#preview_time" do
    it "returns a Time" do
      expect(container.preview_time).to be_kind_of(Time)
    end
  end

  describe "#placed_time" do
    it "returns a Time" do
      expect(container.placed_time).to be_kind_of(Time)
    end
  end

  describe "#direction" do
    it "returns a Symbol" do
      expect(container.direction).to be_kind_of(Symbol)
    end
  end

  describe "#opening?" do
    it "returns a boolean" do
      expect(container.opening?).to eq(true).or(eq(false))
    end
  end

  describe "#closing?" do
    it "returns a boolean" do
      expect(container.closing?).to eq(true).or(eq(false))
    end
  end

  describe "#delta" do
    it "returns a Float" do
      expect(container.delta).to be_kind_of(Float)
    end
  end

  describe "#gamma" do
    it "returns a Float" do
      expect(container.gamma).to be_kind_of(Float)
    end
  end

  describe "#theta" do
    it "returns a Float" do
      expect(container.theta).to be_kind_of(Float)
    end
  end

  describe "#vega" do
    it "returns a Float" do
      expect(container.vega).to be_kind_of(Float)
    end
  end

  describe "#rho" do
    it "returns a Float" do
      expect(container.rho).to be_kind_of(Float)
    end
  end

  describe "#iv" do
    it "returns a Float" do
      expect(container.iv).to be_kind_of(Float)
    end
  end
end

RSpec.shared_examples "leg interface - short position" do
  describe "#unfilled_quantity" do
    it "returns 0" do
      expect(container.unfilled_quantity).to eq 0
    end
  end

  describe "#filled_quantity" do
    it "returns a negative number" do
      expect(container.filled_quantity).to be_negative
    end
  end

  describe "#side" do
    it "returns :short" do
      expect(container.side).to eq :short
    end
  end

  describe "#execution_time" do
    it "returns a Time that is not EPOCH" do
      expect(container.execution_time.year).not_to eq TTK::Containers::Leg::EPOCH.year
    end
  end

  describe "#preview_time" do
    it "returns EPOCH" do
      expect(container.preview_time).to eq TTK::Containers::Leg::EPOCH
    end
  end

  describe "#placed_time" do
    it "returns EPOCH" do
      expect(container.placed_time).to eq TTK::Containers::Leg::EPOCH
    end
  end
end

RSpec.shared_examples "leg interface - long position" do
  describe "#unfilled_quantity" do
    it "returns 0" do
      expect(container.unfilled_quantity).to eq 0
    end
  end

  describe "#filled_quantity" do
    it "returns a positive number" do
      expect(container.filled_quantity).to be_positive
    end
  end

  describe "#side" do
    it "returns :long" do
      expect(container.side).to eq :long
    end
  end

  describe "#execution_time" do
    it "returns a Time that is not EPOCH" do
      expect(container.execution_time.year).not_to eq TTK::Containers::Leg::EPOCH.year
    end
  end

  describe "#preview_time" do
    it "returns EPOCH" do
      expect(container.preview_time).to eq TTK::Containers::Leg::EPOCH
    end
  end

  describe "#placed_time" do
    it "returns EPOCH" do
      expect(container.placed_time).to eq TTK::Containers::Leg::EPOCH
    end
  end
end

RSpec.shared_examples "leg interface - short order" do
  describe "#unfilled_quantity" do
    it "returns a positive number" do
      expect(container.unfilled_quantity).to be_positive
    end
  end

  describe "#filled_quantity" do
    it "returns a value" do
      expect(container.filled_quantity).to eq filled_quantity
    end
  end

  describe "#side" do
    it "returns :short" do
      expect(container.side).to eq :short
    end
  end

  describe "#execution_time" do
    it "returns a Time that is not EPOCH" do
      expect(container.preview_time).to eq TTK::Containers::Leg::EPOCH
    end
  end

  describe "#preview_time" do
    it "returns a Time that is not EPOCH" do
      expect(container.execution_time.year).not_to eq TTK::Containers::Leg::EPOCH.year
    end
  end

  describe "#placed_time" do
    it "returns a Time that is not EPOCH" do
      expect(container.execution_time.year).not_to eq TTK::Containers::Leg::EPOCH.year
    end
  end
end

RSpec.shared_examples "leg interface - long order" do
  describe "#unfilled_quantity" do
    it "returns a positive number" do
      expect(container.unfilled_quantity).to be_positive
    end
  end

  describe "#filled_quantity" do
    it "returns a value" do
      expect(container.filled_quantity).to eq filled_quantity
    end
  end

  describe "#side" do
    it "returns :long" do
      expect(container.side).to eq :long
    end
  end

  describe "#execution_time" do
    it "returns a Time that is not EPOCH" do
      expect(container.preview_time).to eq TTK::Containers::Leg::EPOCH
    end
  end

  describe "#preview_time" do
    it "returns a Time that is not EPOCH" do
      expect(container.execution_time.year).not_to eq TTK::Containers::Leg::EPOCH.year
    end
  end

  describe "#placed_time" do
    it "returns a Time that is not EPOCH" do
      expect(container.execution_time.year).not_to eq TTK::Containers::Leg::EPOCH.year
    end
  end
end

RSpec.shared_examples "leg interface - long call greeks" do
  describe "#delta" do
    it "returns a positive number" do
      expect(container.delta).to be_positive
    end

    it "returns the quote delta" do
      expect(container.delta).to eq quote.delta
    end
  end

  describe "#gamma" do
    it "returns a positive number" do
      expect(container.gamma).to be_positive
    end

    it "returns the quote gamma" do
      expect(container.gamma).to eq quote.gamma
    end
  end

  describe "#theta" do
    it "returns a negative number" do
      expect(container.theta).to be_negative
    end

    it "returns the quote theta" do
      expect(container.theta).to eq quote.theta
    end
  end

  describe "#vega" do
    it "returns a positive number" do
      expect(container.vega).to be_positive
    end

    it "returns the quote vega" do
      expect(container.vega).to eq quote.vega
    end
  end

  describe "#rho" do
    it "returns a positive number" do
      expect(container.rho).to be_positive
    end

    it "returns the quote rho" do
      expect(container.rho).to eq quote.rho
    end
  end

  describe "#iv" do
    it "returns a positive number" do
      expect(container.iv).to be_positive
    end

    it "returns the quote iv" do
      expect(container.iv).to eq quote.iv
    end
  end
end

RSpec.shared_examples "leg interface - long put greeks" do
  describe "#delta" do
    it "returns a negative number" do
      expect(container.delta).to be_negative
    end

    it "returns the quote delta" do
      expect(container.delta).to eq quote.delta
    end
  end

  describe "#gamma" do
    it "returns a positive number" do
      expect(container.gamma).to be_positive
    end

    it "returns the quote gamma" do
      expect(container.gamma).to eq quote.gamma
    end
  end

  describe "#theta" do
    it "returns a negative number" do
      expect(container.theta).to be_negative
    end

    it "returns the quote theta" do
      expect(container.theta).to eq quote.theta
    end
  end

  describe "#vega" do
    it "returns a positive number" do
      expect(container.vega).to be_positive
    end

    it "returns the quote vega" do
      expect(container.vega).to eq quote.vega
    end
  end

  describe "#rho" do
    it "returns a positive number" do
      expect(container.rho).to be_positive
    end

    it "returns the quote rho" do
      expect(container.rho).to eq quote.rho
    end
  end

  describe "#iv" do
    it "returns a positive number" do
      expect(container.iv).to be_positive
    end

    it "returns the quote iv" do
      expect(container.iv).to eq quote.iv
    end
  end
end

RSpec.shared_examples "leg interface - short call greeks" do
  describe "#delta" do
    it "returns a negative number" do
      expect(container.delta).to be_negative
    end

    it "returns the same absolute value of quote delta" do
      expect(container.delta.abs).to eq quote.delta.abs
    end
  end

  describe "#gamma" do
    it "returns a negative number" do
      expect(container.gamma).to be_negative
    end

    it "returns the same absolute value of quote gamma" do
      expect(container.gamma.abs).to eq quote.gamma.abs
    end
  end

  describe "#theta" do
    it "returns a positive number" do
      expect(container.theta).to be_positive
    end

    it "returns the same absolute value of quote theta" do
      expect(container.theta.abs).to eq quote.theta.abs
    end
  end

  describe "#vega" do
    it "returns a negative number" do
      expect(container.vega).to be_negative
    end

    it "returns the same absolute value of quote vega" do
      expect(container.vega.abs).to eq quote.vega.abs
    end
  end

  describe "#rho" do
    it "returns a negative number" do
      expect(container.rho).to be_negative
    end

    it "returns the same absolute value of quote rho" do
      expect(container.rho.abs).to eq quote.rho.abs
    end
  end

  describe "#iv" do
    it "returns a positive number" do
      expect(container.iv).to be_positive
    end

    it "returns the quote iv" do
      expect(container.iv).to eq quote.iv
    end
  end
end

RSpec.shared_examples "leg interface - short put greeks" do
  describe "#delta" do
    it "returns a positive number" do
      expect(container.delta).to be_positive
    end

    it "returns the same absolute value of quote delta" do
      expect(container.delta.abs).to eq quote.delta.abs
    end
  end

  describe "#gamma" do
    it "returns a negative number" do
      expect(container.gamma).to be_negative
    end

    it "returns the same absolute value of quote gamma" do
      expect(container.gamma.abs).to eq quote.gamma.abs
    end
  end

  describe "#theta" do
    it "returns a positive number" do
      expect(container.theta).to be_positive
    end

    it "returns the same absolute value of quote theta" do
      expect(container.theta.abs).to eq quote.theta.abs
    end
  end

  describe "#vega" do
    it "returns a negative number" do
      expect(container.vega).to be_negative
    end

    it "returns the same absolute value of quote vega" do
      expect(container.vega.abs).to eq quote.vega.abs
    end
  end

  describe "#rho" do
    it "returns a negative number" do
      expect(container.rho).to be_negative
    end

    it "returns the same absolute value of quote rho" do
      expect(container.rho.abs).to eq quote.rho.abs
    end
  end

  describe "#iv" do
    it "returns a positive number" do
      expect(container.iv).to be_positive
    end

    it "returns the quote iv" do
      expect(container.iv).to eq quote.iv
    end
  end
end

RSpec.shared_examples "leg interface - basic behavior" do
  # it_behaves_like "product interface - basic behaviors"

  describe "#unfilled_quantity" do
    it "returns the correct value" do
      expect(container.unfilled_quantity).to eq unfilled_quantity
    end
  end

  describe "#filled_quantity" do
    it "returns the correct value" do
      expect(container.filled_quantity).to eq filled_quantity
    end
  end

  describe "#side" do
    it "returns a symbol" do
      expect(container.side).to be_kind_of(Symbol)
    end
  end

  describe "#fees" do
    it "returns a Float" do
      expect(container.fees).to be_kind_of(Float)
    end
  end

  describe "#commission" do
    it "returns a Float" do
      expect(container.commission).to be_kind_of(Float)
    end
  end

  describe "#execution_price" do
    it "returns a Float" do
      expect(container.execution_price).to be_kind_of(Float)
    end
  end

  describe "#order_price" do
    it "returns a Float" do
      expect(container.order_price).to be_kind_of(Float)
    end
  end

  describe "#stop_price" do
    it "returns a Float" do
      expect(container.stop_price).to be_kind_of(Float)
    end
  end

  describe "#execution_time" do
    it "returns a Time" do
      expect(container.execution_time).to be_kind_of(Time)
    end
  end

  describe "#preview_time" do
    it "returns a Time" do
      expect(container.preview_time).to be_kind_of(Time)
    end
  end

  describe "#placed_time" do
    it "returns a Time" do
      expect(container.placed_time).to be_kind_of(Time)
    end
  end

  context "when it is opening" do
    let(:direction) { :opening }

    describe "#direction" do
      it "returns :opening" do
        expect(container.direction).to eq :opening
      end
    end

    describe "#opening?" do
      it "returns true" do
        expect(container.opening?).to be true
      end
    end

    describe "#closing?" do
      it "returns false" do
        expect(container.closing?).to be false
      end
    end
  end

  describe "#leg_status" do
    context "when open" do
      let(:leg_status) { :open }
      it "returns :open" do
        expect(container.leg_status).to eq :open
      end
    end

    context "when cancelled" do
      let(:leg_status) { :cancelled }
      it "returns :cancelled" do
        expect(container.leg_status).to eq :cancelled
      end
    end

    context "when executed" do
      let(:leg_status) { :executed }
      it "returns :executed" do
        expect(container.leg_status).to eq :executed
      end
    end

    context "when rejected" do
      let(:leg_status) { :rejected }
      it "returns :rejected" do
        expect(container.leg_status).to eq :rejected
      end
    end
  end
end

RSpec.shared_examples "leg interface - more order behavior" do
  context "when it is closing" do
    # only Order legs will respect this... Position legs hard code
    # to :opening since that's their definition
    let(:direction) { :closing }

    describe "#direction" do
      it "returns :closing" do
        expect(container.direction).to eq :closing
      end
    end

    describe "#opening?" do
      it "returns false" do
        expect(container.opening?).to be false
      end
    end

    describe "#closing?" do
      it "returns true" do
        expect(container.closing?).to be true
      end
    end
  end
end
