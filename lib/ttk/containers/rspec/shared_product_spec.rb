# frozen_string_literal: true

$LOAD_PATH << File.expand_path(File.join(__dir__, "..", "..", "..")) # useful when this file is directly required by other gems
require "ttk/containers/product/shared"

require_relative "shared_expiration_spec"

# All shared example groups expect the original context to provide a #container
# method that returns a valid Product container instance

RSpec.shared_examples "product interface with required methods" do |parent_module|
  parent_module::Interface.required_methods.each do |rm|
    it "implements expected interface method :#{rm}" do
      expect(container).to respond_to(rm)
    end
  end

  # Confirm that the container forwarding to Expiration is setup and active
  include_examples "expiration interface with required methods", TTK::Containers::Product::Expiration do
    let(:expiration) { container.expiration }
  end

  # Type checking...

  describe "#call?" do
    it "returns a boolean" do
      expect(container.call?).to be(true).or(be(false))
    end
  end

  describe "#put?" do
    it "returns a boolean" do
      expect(container.put?).to be(true).or(be(false))
    end
  end

  describe "#equity_option?" do
    it "returns a boolean" do
      expect(container.equity_option?).to be(true).or(be(false))
    end
  end

  describe "#equity?" do
    it "returns a boolean" do
      expect(container.equity?).to be(true).or(be(false))
    end
  end

  describe "#strike" do
    it "returns a Numeric" do
      expect(container.strike).to be_kind_of(Numeric)
    end
  end

  describe "#==" do
    it "returns a boolean" do
      expect(container == 3).to be(true).or(be(false))
    end
  end

  describe "#expiration" do
    it "responds to :year" do
      expect(container.expiration).to respond_to(:year)
    end
    it "responds to :month" do
      expect(container.expiration).to respond_to(:month)
    end
    it "responds to :day" do
      expect(container.expiration).to respond_to(:day)
    end
  end

  describe "#osi" do
    it "returns a String" do
      expect(container.osi).to be_kind_of(String)
    end
  end
end

RSpec.shared_examples "product interface - osi call" do
  context "single digit strike" do
    let(:strike) { 7 }

    it "returns SPY---210211C00007000" do
      expect(container.osi).to eq "SPY---210211C00007000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "2 digit strike" do
    let(:strike) { 71 }

    it "returns SPY---210211C00071000" do
      expect(container.osi).to eq "SPY---210211C00071000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "3 digit strike" do
    let(:strike) { 712 }

    it "returns SPY---210211C00712000" do
      expect(container.osi).to eq "SPY---210211C00712000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "4 digit strike" do
    let(:strike) { 7123 }

    it "returns SPY---210211C07123000" do
      expect(container.osi).to eq "SPY---210211C07123000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "5 digit strike" do
    let(:strike) { 71_234 }

    it "returns SPY---210211C71234000" do
      expect(container.osi).to eq "SPY---210211C71234000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end
end

RSpec.shared_examples "product interface - osi put" do
  context "single digit strike" do
    let(:strike) { 7 }

    it "returns SPY---210211P00007000" do
      expect(container.osi).to eq "SPY---210211P00007000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "2 digit strike" do
    let(:strike) { 71 }

    it "returns SPY---210211P00071000" do
      expect(container.osi).to eq "SPY---210211P00071000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "3 digit strike" do
    let(:strike) { 712 }

    it "returns SPY---210211P00712000" do
      expect(container.osi).to eq "SPY---210211P00712000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "4 digit strike" do
    let(:strike) { 7123 }

    it "returns SPY---210211P07123000" do
      expect(container.osi).to eq "SPY---210211P07123000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "5 digit strike" do
    let(:strike) { 71_234 }

    it "returns SPY---210211P71234000" do
      expect(container.osi).to eq "SPY---210211P71234000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end
end

RSpec.shared_examples "product interface with basic call option behaviors" do
  let(:callput) { :call }

  describe "#call?" do
    it "returns true" do
      expect(container.call?).to be true
    end
  end

  describe "#put?" do
    it "returns false" do
      expect(container.put?).to be false
    end
  end

  describe "#equity_option?" do
    it "returns true" do
      expect(container.equity_option?).to be true
    end
  end

  describe "#equity?" do
    it "returns false" do
      expect(container.equity?).to be false
    end
  end

  describe "#strike" do
    it "returns the strike" do
      expect(container.strike).to eq strike
    end
  end

  describe "#==" do
    context "when given an exact match" do
      let(:duplicate) { container }
      it "returns true" do
        expect(container == duplicate).to be true
      end
    end

    context "when given an inexact match" do
      let(:duplicate) { different_container }
      it "returns false" do
        expect(container == duplicate).to be false
      end
    end
  end

  describe "#expiration" do
    include_examples "expiration interface with basic behaviors" do
      let(:expiration) { container.expiration }
    end
  end

  describe "#osi" do
    include_examples "product interface - osi call" do
      let(:symbol) { "SPY" }
      let(:symbol) { "SPY" }
      let(:strike) { 155 }
      let(:year) { 2021 }
      let(:month) { 2 }
      let(:day) { 11 }
    end
  end
end

RSpec.shared_examples "product interface with basic put option behaviors" do
  let(:callput) { :put }

  describe "#call?" do
    it "returns false" do
      expect(container.call?).to be false
    end
  end

  describe "#put?" do
    it "returns true" do
      expect(container.put?).to be true
    end
  end

  describe "#equity_option?" do
    it "returns true" do
      expect(container.equity_option?).to be true
    end
  end

  describe "#equity?" do
    it "returns false" do
      expect(container.equity?).to be false
    end
  end

  describe "#strike" do
    it "returns the strike" do
      expect(container.strike).to eq strike
    end
  end

  describe "#==" do
    context "when given an exact match" do
      let(:duplicate) { container }
      it "returns true" do
        expect(container == duplicate).to be true
      end
    end

    context "when given an inexact match" do
      let(:duplicate) { different_container }
      it "returns false" do
        expect(container == duplicate).to be false
      end
    end
  end

  describe "#expiration" do
    include_examples "expiration interface with basic behaviors" do
      let(:expiration) { container.expiration }
    end
  end

  describe "#osi" do
    include_examples "product interface - osi put" do
      let(:symbol) { "SPY" }
      let(:strike) { 155 }
      let(:year) { 2021 }
      let(:month) { 2 }
      let(:day) { 11 }
    end
  end
end

RSpec.shared_examples "product interface with basic equity instrument behaviors" do
  let(:security_type) { :equity }

  describe "#call?" do
    it "returns false" do
      expect(container.call?).to be false
    end
  end

  describe "#put?" do
    it "returns false" do
      expect(container.put?).to be false
    end
  end

  describe "#equity_option?" do
    it "returns false" do
      expect(container.equity_option?).to be false
    end
  end

  describe "#equity?" do
    it "returns true" do
      expect(container.equity?).to be true
    end
  end

  describe "#strike" do
    it "returns 0" do
      expect(container.strike).to eq 0
    end
  end

  describe "#==" do
    context "when given an exact match" do
      let(:duplicate) { container }
      it "returns true" do
        expect(container == duplicate).to be true
      end
    end

    context "when given an inexact match" do
      let(:duplicate) { different_container }
      it "returns false" do
        expect(container == duplicate).to be false
      end
    end
  end

  describe "#expiration" do
    let(:expiration) { container.expiration }

    it "returns 1970 as the year" do
      expect(expiration.year).to eq 1970
    end

    it "returns 1 as the month" do
      expect(expiration.month).to eq 1
    end

    it "returns 1 as the day" do
      expect(expiration.day).to eq 1
    end
  end

  describe "#osi" do
    let(:symbol) { "SPY" }
    it "returns the equity symbol" do
      expect(container.osi).to eq symbol
    end
  end
end
