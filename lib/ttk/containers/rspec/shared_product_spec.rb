$: << File.expand_path(File.join(__dir__, "..", "..", "..")) # useful when this file is directly required by other gems
require "ttk/containers/product/shared"

require_relative "shared_expiration_spec"

# All shared example groups expect the original context to provide a #product
# method that returns a valid Product container instance

RSpec.shared_examples "product interface - required methods" do |parent_module|
  parent_module::Interface.required_methods.each do |rm|
    it "conforms to the expected interface by responding to method #{rm}" do
      expect(container).to respond_to(rm)
    end
  end
end

RSpec.shared_examples "product interface - osi call" do
  context "single digit strike" do
    let(:strike) { 7 }

    it "returns SPY---211211C00007000" do
      expect(container.osi).to eq "SPY---211211C00007000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "2 digit strike" do
    let(:strike) { 71 }

    it "returns SPY---211211C00071000" do
      expect(container.osi).to eq "SPY---211211C00071000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "3 digit strike" do
    let(:strike) { 712 }

    it "returns SPY---211211C00712000" do
      expect(container.osi).to eq "SPY---211211C00712000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "4 digit strike" do
    let(:strike) { 7123 }

    it "returns SPY---211211C07123000" do
      expect(container.osi).to eq "SPY---211211C07123000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "5 digit strike" do
    let(:strike) { 71234 }

    it "returns SPY---211211C71234000" do
      expect(container.osi).to eq "SPY---211211C71234000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end
end

RSpec.shared_examples "product interface - osi put" do
  context "single digit strike" do
    let(:strike) { 7 }

    it "returns SPY---211211P00007000" do
      expect(container.osi).to eq "SPY---211211P00007000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "2 digit strike" do
    let(:strike) { 71 }

    it "returns SPY---211211P00071000" do
      expect(container.osi).to eq "SPY---211211P00071000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "3 digit strike" do
    let(:strike) { 712 }

    it "returns SPY---211211P00712000" do
      expect(container.osi).to eq "SPY---211211P00712000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "4 digit strike" do
    let(:strike) { 7123 }

    it "returns SPY---211211P07123000" do
      expect(container.osi).to eq "SPY---211211P07123000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end

  context "5 digit strike" do
    let(:strike) { 71234 }

    it "returns SPY---211211P71234000" do
      expect(container.osi).to eq "SPY---211211P71234000"
    end

    it "returns a 21-char string" do
      expect(container.osi.size).to eq 21
    end
  end
end

RSpec.shared_examples "product interface - call" do
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
    it "returns true for exact matches" do
      expect(container == exact_duplicate).to be true
    end

    it "returns false for inexact matches" do
      expect(container == different_duplicate).to be false
    end
  end

  describe "#expiration_date" do
    let(:expiration) { container.expiration_date }

    include_examples "expiration interface - year"
    include_examples "expiration interface - month"
    include_examples "expiration interface - day"
  end

  describe "#osi" do
    include_examples "product interface - osi call"
  end
end

RSpec.shared_examples "product interface - put" do
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
    it "returns true for exact matches" do
      expect(container == exact_duplicate).to be true
    end

    it "returns false for inexact matches" do
      expect(container == different_duplicate).to be false
    end
  end

  describe "#expiration_date" do
    let(:expiration) { container.expiration_date }

    include_examples "expiration interface - year"
    include_examples "expiration interface - month"
    include_examples "expiration interface - day"
  end

  describe "#osi" do
    include_examples "product interface - osi put"
  end
end

RSpec.shared_examples "product interface - equity" do
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
    it "returns true for exact matches" do
      expect(container == exact_duplicate).to be true
    end

    it "returns false for inexact matches" do
      expect(container == different_duplicate).to be false
    end
  end

  describe "#expiration_date" do
    let(:expiration) { container.expiration_date }

    include_examples "expiration interface - year 0"
    include_examples "expiration interface - month 0"
    include_examples "expiration interface - day 0"
  end

  describe "#osi" do
    it "returns SPY" do
      expect(container.osi).to eq "SPY"
    end
  end
end