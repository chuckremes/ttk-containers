require "date"

# For tests to run, they all expect a method #expiration to be defined and available.
#
RSpec.shared_examples "expiration interface - required methods" do |parent_module|
  parent_module::Interface.required_methods.each do |rm|
    it "conforms to the expected interface by responding to method #{rm}" do
      expect(expiration).to respond_to(rm)
    end
  end
end

RSpec.shared_examples "expiration interface - year" do
  describe "#year" do
    it "returns an integer" do
      expect(expiration.year).to be_kind_of(Numeric)
    end

    it "returns the year it was given" do
      expect(expiration.year).to eq year
    end
  end
end

RSpec.shared_examples "expiration interface - month" do
  describe "#month" do
    it "returns an integer" do
      expect(expiration.month).to be_kind_of(Numeric)
    end

    it "returns the month it was given" do
      expect(expiration.month).to eq month
    end
  end
end

RSpec.shared_examples "expiration interface - day" do
  describe "#day" do
    it "returns an integer" do
      expect(expiration.day).to be_kind_of(Numeric)
    end

    it "returns the day it was given" do
      expect(expiration.day).to eq day
    end
  end
end

# Special case for when the Product is an Equity or other type that has no expiration
#
RSpec.shared_examples "expiration interface - year 0" do
  describe "#year" do
    it "returns an integer" do
      expect(expiration.year).to be_kind_of(Numeric)
    end

    it "returns 0" do
      expect(expiration.year).to eq 0
    end
  end
end

RSpec.shared_examples "expiration interface - month 0" do
  describe "#month" do
    it "returns an integer" do
      expect(expiration.month).to be_kind_of(Numeric)
    end

    it "returns 0" do
      expect(expiration.month).to eq 0
    end
  end
end

RSpec.shared_examples "expiration interface - day 0" do
  describe "#day" do
    it "returns an integer" do
      expect(expiration.day).to be_kind_of(Numeric)
    end

    it "returns 0" do
      expect(expiration.day).to eq 0
    end
  end
end
