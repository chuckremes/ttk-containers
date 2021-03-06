# frozen_string_literal: true

$LOAD_PATH << File.expand_path(File.join(__dir__, "..", "..", "..")) # useful when this file is directly required by other gems
require "ttk/containers/quote/shared"
require_relative "shared_product_spec"

RSpec.shared_examples "quote interface with required methods" do |parent_module|
  parent_module::Interface.required_methods.each do |rm|
    it "implements expected interface method :#{rm}" do
      expect(container).to respond_to(rm)
    end
  end

  include_examples "product interface with required methods", TTK::Containers::Product

  # Type check...

  describe "#quote_timestamp" do
    it "returns a Time" do
      expect(container.quote_timestamp).to be_kind_of(Time)
    end
  end

  describe "#quote_status" do
    it "returns a Symbol" do
      expect(container.quote_status).to be_kind_of(Symbol)
    end
  end

  describe "#ask" do
    it "returns a Float" do
      expect(container.ask).to be_kind_of(Float)
    end
  end

  describe "#bid" do
    it "returns a Float" do
      expect(container.bid).to be_kind_of(Float)
    end
  end

  describe "#last" do
    it "returns a Float" do
      expect(container.last).to be_kind_of(Float)
    end
  end

  describe "#volume" do
    it "returns a Numeric" do
      expect(container.volume).to be_kind_of(Numeric)
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

  describe "#intrinsic" do
    it "returns a Float" do
      expect(container.intrinsic).to be_kind_of(Float)
    end
  end

  describe "#extrinsic" do
    it "returns a Float" do
      expect(container.extrinsic).to be_kind_of(Float)
    end
  end

  describe "#dte" do
    it "returns a Numeric" do
      expect(container.dte).to be_kind_of(Numeric)
    end
  end

  describe "#open_interest" do
    it "returns a Numeric" do
      expect(container.open_interest).to be_kind_of(Numeric)
    end
  end

  describe "#multiplier" do
    it "returns a Numeric" do
      expect(container.multiplier).to be_kind_of(Numeric)
    end
  end

end

RSpec.shared_examples "quote interface - methods equity" do
  describe "#quote_timestamp" do
    it "returns the initialization value" do
      expect(container.quote_timestamp).to eq quote_timestamp
    end
  end

  describe "#quote_status" do
    it "returns the initialization value" do
      expect(container.quote_status).to eq quote_status
    end
  end

  describe "#ask" do
    it "returns the initialization value" do
      expect(container.ask).to eq ask
    end
  end

  describe "#bid" do
    it "returns the initialization value" do
      expect(container.bid).to eq bid
    end
  end

  describe "#last" do
    it "returns the initialization value" do
      expect(container.last).to eq last
    end
  end

  describe "#volume" do
    it "returns the initialization value" do
      expect(container.volume).to eq volume
    end
  end

  describe "#delta" do
    it "returns 0" do
      expect(container.delta).to eq 0
    end
  end

  describe "#gamma" do
    it "returns 0" do
      expect(container.gamma).to eq 0
    end
  end

  describe "#theta" do
    it "returns 0" do
      expect(container.theta).to eq 0
    end
  end

  describe "#vega" do
    it "returns 0" do
      expect(container.vega).to eq 0
    end
  end

  describe "#rho" do
    it "returns 0" do
      expect(container.rho).to eq 0
    end
  end

  describe "#iv" do
    it "returns 0" do
      expect(container.iv).to eq 0
    end
  end

  describe "#intrinsic" do
    it "returns 0" do
      expect(container.intrinsic).to eq 0
    end
  end

  describe "#extrinsic" do
    it "returns 0" do
      expect(container.extrinsic).to eq 0
    end
  end

  describe "#dte" do
    it "returns 0" do
      expect(container.dte).to eq 0
    end
  end

  describe "#open_interest" do
    it "returns 0" do
      expect(container.open_interest).to eq 0
    end
  end

  describe "#multiplier" do
    it "returns 1" do
      expect(container.multiplier).to eq 1
    end
  end
end

RSpec.shared_examples "quote interface - methods equity_option" do
  describe "#quote_timestamp" do
    it "returns the initialization value" do
      expect(container.quote_timestamp).to eq quote_timestamp
    end
  end

  describe "#quote_status" do
    it "returns the initialization value" do
      expect(container.quote_status).to eq quote_status
    end
  end

  describe "#ask" do
    it "returns the initialization value" do
      expect(container.ask).to eq ask
    end
  end

  describe "#bid" do
    it "returns the initialization value" do
      expect(container.bid).to eq bid
    end
  end

  describe "#last" do
    it "returns the initialization value" do
      expect(container.last).to eq last
    end
  end

  describe "#volume" do
    it "returns the initialization value" do
      expect(container.volume).to eq volume
    end
  end

  describe "#delta" do
    it "returns the initialization value" do
      expect(container.delta).to eq delta
    end
  end

  describe "#gamma" do
    it "returns the initialization value" do
      expect(container.gamma).to eq gamma
    end
  end

  describe "#theta" do
    it "returns the initialization value" do
      expect(container.theta).to eq theta
    end
  end

  describe "#vega" do
    it "returns the initialization value" do
      expect(container.vega).to eq vega
    end
  end

  describe "#rho" do
    it "returns the initialization value" do
      expect(container.rho).to eq rho
    end
  end

  describe "#iv" do
    it "returns the initialization value" do
      expect(container.iv).to eq iv
    end
  end

  describe "#intrinsic" do
    it "returns the initialization value" do
      expect(container.intrinsic).to eq intrinsic
    end
  end

  describe "#extrinsic" do
    it "returns the initialization value" do
      expect(container.extrinsic).to eq extrinsic
    end
  end

  describe "#dte" do
    it "returns the initialization value" do
      expect(container.dte).to eq dte
    end
  end

  describe "#open_interest" do
    it "returns the initialization value" do
      expect(container.open_interest).to eq open_interest
    end
  end

  describe "#multiplier" do
    it "returns the initialization value" do
      expect(container.multiplier).to eq multiplier
    end
  end
end

RSpec.shared_examples "quote interface - update equity" do
  describe "#update_quote" do
    context "when quote_timestamp changes" do
      it "returns the new value after update" do
        expect(container.quote_timestamp).to eq quote_timestamp
        obj = update_object.set(:quote_timestamp, quote_timestamp + 1)
        container.update_quote(obj)
        expect(container.quote_timestamp).to eq quote_timestamp + 1
      end
    end

    context "when quote_status changes" do
      it "returns the new value after update" do
        expect(container.quote_status).to eq quote_status
        obj = update_object.set(:quote_status, :other)
        container.update_quote(obj)
        expect(container.quote_status).to eq :other
      end
    end

    context "when bid changes" do
      it "returns the new value after update" do
        expect(container.bid).to eq bid
        obj = update_object.set(:bid, bid + 1)
        container.update_quote(obj)
        expect(container.bid).to eq bid + 1
      end
    end

    context "when ask changes" do
      it "returns the new value after update" do
        expect(container.ask).to eq ask
        obj = update_object.set(:ask, ask + 1)
        container.update_quote(obj)
        expect(container.ask).to eq ask + 1
      end
    end

    context "when last changes" do
      it "returns the new value after update" do
        expect(container.last).to eq last
        obj = update_object.set(:last, last + 1)
        container.update_quote(obj)
        expect(container.last).to eq last + 1
      end
    end

    context "when volume changes" do
      it "returns the new value after update" do
        expect(container.volume).to eq volume
        obj = update_object.set(:volume, volume + 1)
        container.update_quote(obj)
        expect(container.volume).to eq volume + 1
      end
    end

    context "when multiplier changes" do
      it "returns 1" do
        expect(container.multiplier).to eq 1
        obj = update_object.set(:multiplier, multiplier + 1)
        container.update_quote(obj)
        expect(container.multiplier).to eq 1
      end
    end

    context "when open_interest changes" do
      it "returns 0" do
        expect(container.open_interest).to eq 0
        obj = update_object.set(:open_interest, open_interest + 1)
        container.update_quote(obj)
        expect(container.open_interest).to eq 0
      end
    end

    context "when dte changes" do
      it "returns 0" do
        expect(container.dte).to eq 0
        obj = update_object.set(:dte, dte + 1)
        container.update_quote(obj)
        expect(container.dte).to eq 0
      end
    end

    context "when intrinsic changes" do
      it "returns 0" do
        expect(container.intrinsic).to eq 0
        obj = update_object.set(:intrinsic, intrinsic + 1)
        container.update_quote(obj)
        expect(container.intrinsic).to eq 0
      end
    end

    context "when extrinsic changes" do
      it "returns 0" do
        expect(container.extrinsic).to eq 0
        obj = update_object.set(:extrinsic, extrinsic + 1)
        container.update_quote(obj)
        expect(container.extrinsic).to eq 0
      end
    end

    context "when delta changes" do
      it "returns 0" do
        expect(container.delta).to eq 0
        obj = update_object.set(:delta, delta + 1)
        container.update_quote(obj)
        expect(container.delta).to eq 0
      end
    end

    context "when gamma changes" do
      it "returns 0" do
        expect(container.gamma).to eq 0
        obj = update_object.set(:gamma, gamma + 1)
        container.update_quote(obj)
        expect(container.gamma).to eq 0
      end
    end

    context "when theta changes" do
      it "returns 0" do
        expect(container.theta).to eq 0
        obj = update_object.set(:theta, theta + 1)
        container.update_quote(obj)
        expect(container.theta).to eq 0
      end
    end

    context "when vega changes" do
      it "returns 0" do
        expect(container.vega).to eq 0
        obj = update_object.set(:vega, vega + 1)
        container.update_quote(obj)
        expect(container.vega).to eq 0
      end
    end

    context "when rho changes" do
      it "returns 0" do
        expect(container.rho).to eq 0
        obj = update_object.set(:rho, rho + 1)
        container.update_quote(obj)
        expect(container.rho).to eq 0
      end
    end

    context "when iv changes" do
      it "returns 0" do
        expect(container.iv).to eq 0
        obj = update_object.set(:iv, iv + 1)
        container.update_quote(obj)
        expect(container.iv).to eq 0
      end
    end
  end
end

RSpec.shared_examples "quote interface - update equity_option" do
  describe "#update_quote" do
    context "when quote_timestamp changes" do
      it "returns the new value after update" do
        expect(container.quote_timestamp).to eq quote_timestamp
        obj = update_object.set(:quote_timestamp, quote_timestamp + 1)
        container.update_quote(obj)
        expect(container.quote_timestamp).to eq quote_timestamp + 1
      end
    end

    context "when quote_status changes" do
      it "returns the new value after update" do
        expect(container.quote_status).to eq quote_status
        obj = update_object.set(:quote_status, :other)
        container.update_quote(obj)
        expect(container.quote_status).to eq :other
      end
    end

    context "when bid changes" do
      it "returns the new value after update" do
        expect(container.bid).to eq bid
        obj = update_object.set(:bid, bid + 1)
        container.update_quote(obj)
        expect(container.bid).to eq bid + 1
      end
    end

    context "when ask changes" do
      it "returns the new value after update" do
        expect(container.ask).to eq ask
        obj = update_object.set(:ask, ask + 1)
        container.update_quote(obj)
        expect(container.ask).to eq ask + 1
      end
    end

    context "when last changes" do
      it "returns the new value after update" do
        expect(container.last).to eq last
        obj = update_object.set(:last, last + 1)
        container.update_quote(obj)
        expect(container.last).to eq last + 1
      end
    end

    context "when volume changes" do
      it "returns the new value after update" do
        expect(container.volume).to eq volume
        obj = update_object.set(:volume, volume + 1)
        container.update_quote(obj)
        expect(container.volume).to eq volume + 1
      end
    end

    context "when multiplier changes" do
      it "does not return the new value after update" do
        expect(container.multiplier).to eq multiplier
        obj = update_object.set(:multiplier, multiplier + 1)
        container.update_quote(obj)
        expect(container.multiplier).to eq multiplier
      end
    end

    context "when open_interest changes" do
      it "returns the new value after update" do
        expect(container.open_interest).to eq open_interest
        obj = update_object.set(:open_interest, open_interest + 1)
        container.update_quote(obj)
        expect(container.open_interest).to eq open_interest + 1
      end
    end

    context "when dte changes" do
      it "returns the new value after update" do
        expect(container.dte).to eq dte
        obj = update_object.set(:dte, dte + 1)
        container.update_quote(obj)
        expect(container.dte).to eq dte + 1
      end
    end

    context "when intrinsic changes" do
      it "returns the new value after update" do
        expect(container.intrinsic).to eq intrinsic
        obj = update_object.set(:intrinsic, intrinsic + 1)
        container.update_quote(obj)
        expect(container.intrinsic).to eq intrinsic + 1
      end
    end

    context "when extrinsic changes" do
      it "returns the new value after update" do
        expect(container.extrinsic).to eq extrinsic
        obj = update_object.set(:extrinsic, extrinsic + 1)
        container.update_quote(obj)
        expect(container.extrinsic).to eq extrinsic + 1
      end
    end

    context "when delta changes" do
      it "returns the new value after update" do
        expect(container.delta).to eq delta
        obj = update_object.set(:delta, delta + 1)
        container.update_quote(obj)
        expect(container.delta).to eq delta + 1
      end
    end

    context "when gamma changes" do
      it "returns the new value after update" do
        expect(container.gamma).to eq gamma
        obj = update_object.set(:gamma, gamma + 1)
        container.update_quote(obj)
        expect(container.gamma).to eq gamma + 1
      end
    end

    context "when theta changes" do
      it "returns the new value after update" do
        expect(container.theta).to eq theta
        obj = update_object.set(:theta, theta + 1)
        container.update_quote(obj)
        expect(container.theta).to eq theta + 1
      end
    end

    context "when vega changes" do
      it "returns the new value after update" do
        expect(container.vega).to eq vega
        obj = update_object.set(:vega, vega + 1)
        container.update_quote(obj)
        expect(container.vega).to eq vega + 1
      end
    end

    context "when rho changes" do
      it "returns the new value after update" do
        expect(container.rho).to eq rho
        obj = update_object.set(:rho, rho + 1)
        container.update_quote(obj)
        expect(container.rho).to eq rho + 1
      end
    end

    context "when iv changes" do
      it "returns the new value after update" do
        expect(container.iv).to eq iv
        obj = update_object.set(:iv, iv + 1)
        container.update_quote(obj)
        expect(container.iv).to eq iv + 1
      end
    end
  end
end
