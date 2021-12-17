
$: << File.expand_path(File.join(__dir__, "..", "..", "..")) # useful when this file is directly required by other gems
require "ttk/containers/quotes/quote/shared"
require_relative "shared_product_spec"

RSpec.shared_examples "quote interface - required methods equity" do |parent_module|
  parent_module::Interface.required_methods.each do |rm|
    it "conforms to the expected interface by responding to method #{rm}" do
      expect(container).to respond_to(rm)
    end
  end

  include_examples "product interface - required methods", TTK::Containers::Product
end

RSpec.shared_examples "quote interface - equity methods" do
  describe "#quote_timestamp" do
    it "is a kind of Time" do
      expect(container.quote_timestamp).to be_kind_of(Time)
    end

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
    it "returns a Float" do
      expect(container.ask).to be_kind_of(Float)
    end

    it "returns the initialization value" do
      expect(container.ask).to eq ask
    end
  end

  describe "#bid" do
    it "returns a Float" do
      expect(container.bid).to be_kind_of(Float)
    end

    it "returns the initialization value" do
      expect(container.bid).to eq bid
    end
  end

  describe "#last" do
    it "returns a Float" do
      expect(container.last).to be_kind_of(Float)
    end

    it "returns the initialization value" do
      expect(container.last).to eq last
    end
  end

  describe "#volume" do
    it "returns a Numeric" do
      expect(container.volume).to be_kind_of(Numeric)
    end

    it "returns the initialization value" do
      expect(container.volume).to eq volume
    end
  end
end

RSpec.shared_examples "quote interface - equity update" do
  describe "#update_quote" do
    context "when quote_timestamp changes" do
      it "returns the new value after update" do
        expect(container.quote_timestamp).to eq quote_timestamp
        update_object[:quote_timestamp] = quote_timestamp + 1
        container.update_quote(update_object)
        expect(container.quote_timestamp).to eq quote_timestamp + 1
      end
    end

    context "when quote_status changes" do
      it "returns the new value after update" do
        expect(container.quote_status).to eq quote_status
        update_object[:quote_status] = :other
        container.update_quote(update_object)
        expect(container.quote_status).to eq :other
      end
    end

    context "when bid changes" do
      it "returns the new value after update" do
        expect(container.bid).to eq bid
        update_object[:bid] = bid + 1
        container.update_quote(update_object)
        expect(container.bid).to eq bid + 1
      end
    end

    context "when ask changes" do
      it "returns the new value after update" do
        expect(container.ask).to eq ask
        update_object[:ask] = ask + 1
        container.update_quote(update_object)
        expect(container.ask).to eq ask + 1
      end
    end

    context "when last changes" do
      it "returns the new value after update" do
        expect(container.last).to eq last
        update_object[:last] = last + 1
        container.update_quote(update_object)
        expect(container.last).to eq last + 1
      end
    end

    context "when volume changes" do
      it "returns the new value after update" do
        expect(container.volume).to eq volume
        update_object[:volume] = volume + 1
        container.update_quote(update_object)
        expect(container.volume).to eq volume + 1
      end
    end
  end
end

RSpec.shared_examples "quote interface - required methods equity_option" do |parent_module|
  parent_module::Interface.required_methods.each do |rm|
    it "conforms to the expected interface by responding to method #{rm}" do
      expect(container).to respond_to(rm)
    end
  end

  include_examples "product interface - required methods", TTK::Containers::Product
end

RSpec.shared_examples "quote interface - equity_option methods" do
  include_examples "quote interface - equity methods"

  describe "#delta" do
    it "is a kind of Float" do
      expect(container.delta).to be_kind_of(Float)
    end

    it "returns the initialization value" do
      expect(container.delta).to eq delta
    end
  end

  describe "#gamma" do
    it "is a kind of Float" do
      expect(container.gamma).to be_kind_of(Float)
    end

    it "returns the initialization value" do
      expect(container.gamma).to eq gamma
    end
  end

  describe "#theta" do
    it "is a kind of Float" do
      expect(container.theta).to be_kind_of(Float)
    end

    it "returns the initialization value" do
      expect(container.theta).to eq theta
    end
  end

  describe "#vega" do
    it "is a kind of Float" do
      expect(container.vega).to be_kind_of(Float)
    end

    it "returns the initialization value" do
      expect(container.vega).to eq vega
    end
  end

  describe "#rho" do
    it "is a kind of Float" do
      expect(container.rho).to be_kind_of(Float)
    end

    it "returns the initialization value" do
      expect(container.rho).to eq rho
    end
  end

  describe "#iv" do
    it "is a kind of Float" do
      expect(container.iv).to be_kind_of(Float)
    end

    it "returns the initialization value" do
      expect(container.iv).to eq iv
    end
  end

  describe "#intrinsic" do
    it "is a kind of Float" do
      expect(container.intrinsic).to be_kind_of(Float)
    end

    it "returns the initialization value" do
      expect(container.intrinsic).to eq intrinsic
    end
  end

  describe "#extrinsic" do
    it "is a kind of Float" do
      expect(container.extrinsic).to be_kind_of(Float)
    end

    it "returns the initialization value" do
      expect(container.extrinsic).to eq extrinsic
    end
  end

  describe "#dte" do
    it "is a kind of Numeric" do
      expect(container.dte).to be_kind_of(Numeric)
    end

    it "returns the initialization value" do
      expect(container.dte).to eq dte
    end
  end

  describe "#open_interest" do
    it "is a kind of Numeric" do
      expect(container.open_interest).to be_kind_of(Numeric)
    end

    it "returns the initialization value" do
      expect(container.open_interest).to eq open_interest
    end
  end

  describe "#multiplier" do
    it "is a kind of Numeric" do
      expect(container.multiplier).to be_kind_of(Numeric)
    end

    it "returns the initialization value" do
      expect(container.multiplier).to eq multiplier
    end
  end
end

RSpec.shared_examples "quote interface - equity_option update" do
  describe "#update_quote" do
    context "when quote_timestamp changes" do
      it "returns the new value after update" do
        expect(container.quote_timestamp).to eq quote_timestamp
        update_object[:quote_timestamp] = quote_timestamp + 1
        container.update_quote(update_object)
        expect(container.quote_timestamp).to eq quote_timestamp + 1
      end
    end

    context "when quote_status changes" do
      it "returns the new value after update" do
        expect(container.quote_status).to eq quote_status
        update_object[:quote_status] = :other
        container.update_quote(update_object)
        expect(container.quote_status).to eq :other
      end
    end

    context "when bid changes" do
      it "returns the new value after update" do
        expect(container.bid).to eq bid
        update_object[:bid] = bid + 1
        container.update_quote(update_object)
        expect(container.bid).to eq bid + 1
      end
    end

    context "when ask changes" do
      it "returns the new value after update" do
        expect(container.ask).to eq ask
        update_object[:ask] = ask + 1
        container.update_quote(update_object)
        expect(container.ask).to eq ask + 1
      end
    end

    context "when last changes" do
      it "returns the new value after update" do
        expect(container.last).to eq last
        update_object[:last] = last + 1
        container.update_quote(update_object)
        expect(container.last).to eq last + 1
      end
    end

    context "when volume changes" do
      it "returns the new value after update" do
        expect(container.volume).to eq volume
        update_object[:volume] = volume + 1
        container.update_quote(update_object)
        expect(container.volume).to eq volume + 1
      end
    end

    context "when multiplier changes" do
      it "does not return the new value after update" do
        expect(container.multiplier).to eq multiplier
        update_object[:multiplier] = multiplier + 1
        container.update_quote(update_object)
        expect(container.multiplier).to eq multiplier
      end
    end

    context "when open_interest changes" do
      it "returns the new value after update" do
        expect(container.open_interest).to eq open_interest
        update_object[:open_interest] = open_interest + 1
        container.update_quote(update_object)
        expect(container.open_interest).to eq open_interest + 1
      end
    end

    context "when dte changes" do
      it "returns the new value after update" do
        expect(container.dte).to eq dte
        update_object[:dte] = dte + 1
        container.update_quote(update_object)
        expect(container.dte).to eq dte + 1
      end
    end

    context "when intrinsic changes" do
      it "returns the new value after update" do
        expect(container.intrinsic).to eq intrinsic
        update_object[:intrinsic] = intrinsic + 1
        container.update_quote(update_object)
        expect(container.intrinsic).to eq intrinsic + 1
      end
    end

    context "when extrinsic changes" do
      it "returns the new value after update" do
        expect(container.extrinsic).to eq extrinsic
        update_object[:extrinsic] = extrinsic + 1
        container.update_quote(update_object)
        expect(container.extrinsic).to eq extrinsic + 1
      end
    end

    context "when delta changes" do
      it "returns the new value after update" do
        expect(container.delta).to eq delta
        update_object[:delta] = delta + 1
        container.update_quote(update_object)
        expect(container.delta).to eq delta + 1
      end
    end

    context "when gamma changes" do
      it "returns the new value after update" do
        expect(container.gamma).to eq gamma
        update_object[:gamma] = gamma + 1
        container.update_quote(update_object)
        expect(container.gamma).to eq gamma + 1
      end
    end

    context "when theta changes" do
      it "returns the new value after update" do
        expect(container.theta).to eq theta
        update_object[:theta] = theta + 1
        container.update_quote(update_object)
        expect(container.theta).to eq theta + 1
      end
    end

    context "when vega changes" do
      it "returns the new value after update" do
        expect(container.vega).to eq vega
        update_object[:vega] = vega + 1
        container.update_quote(update_object)
        expect(container.vega).to eq vega + 1
      end
    end

    context "when rho changes" do
      it "returns the new value after update" do
        expect(container.rho).to eq rho
        update_object[:rho] = rho + 1
        container.update_quote(update_object)
        expect(container.rho).to eq rho + 1
      end
    end

    context "when iv changes" do
      it "returns the new value after update" do
        expect(container.iv).to eq iv
        update_object[:iv] = iv + 1
        container.update_quote(update_object)
        expect(container.iv).to eq iv + 1
      end
    end
  end
end
