# frozen_string_literal: true

require "date"

# For tests to run, they all expect a method #expiration to be defined and available.
#
RSpec.shared_examples "expiration interface with required methods" do |parent_module|
  parent_module::Interface.required_methods.each do |rm|
    it "implements expected interface method :#{rm}" do
      expect(expiration).to respond_to(rm)
    end
  end

  # Type checks...

  describe "#year" do
    it "returns an integer" do
      expect(expiration.year).to be_kind_of(Numeric)
    end
  end

  describe "#month" do
    it "returns an integer" do
      expect(expiration.month).to be_kind_of(Numeric)
    end
  end

  describe "#day" do
    it "returns an integer" do
      expect(expiration.day).to be_kind_of(Numeric)
    end
  end

  describe "#date" do
    let(:year) { 2021 }
    let(:month) { 4 }
    let(:day) { 3 }
    it "returns a Date object" do
      expect(expiration.date).to be_kind_of(Date)
    end
  end

  describe "#iso8601" do
    it "returns a String" do
      expect(expiration.iso8601).to be_kind_of(String)
    end
  end
end

RSpec.shared_examples "expiration interface with basic behaviors" do
  describe "#year" do
    context "when given any positive year" do
      let(:year) { 2021 }
      it "returns the year it was given" do
        expect(expiration.year).to eq year
      end
    end

    context "when given year 0" do
      let(:year) { 0 }
      it "returns 1970" do
        expect(expiration.year).to eq 1970
      end
    end
  end

  describe "#month" do
    context "when given any whole number between 1 and 12" do
      let(:month) { 4 }
      it "returns the month it was given" do
        expect(expiration.month).to eq month
      end
    end

    context "when given 0" do
      let(:month) { 0 }
      it "returns 1" do
        expect(expiration.month).to eq 1
      end
    end

    context "when given 13" do
      let(:month) { 13 }
      it "returns 1" do
        expect(expiration.month).to eq 1
      end
    end
  end

  describe "#day" do
    context "when given a whole number between 1 and 31" do
      let(:day) { 22 }
      it "returns the day it was given" do
        expect(expiration.day).to eq day
      end
    end

    context "when given a number outside 1 to 31" do
      let(:day) { 0 }
      it "returns 1" do
        expect(expiration.day).to eq 1
      end
    end
  end

  describe "#date" do
    let(:year) { 2021 }
    let(:month) { 4 }
    let(:day) { 3 }
    it "returns the date given" do
      expect(expiration.date).to eq Date.new(year, month, day)
    end

    context "when given a bad year" do
      let(:year) { 0 }
      it "returns a date with year 1970" do
        expect(expiration.date.year).to eq 1970
      end
    end
  end

  describe "#iso8601" do
    it "returns an 8-char string in the form YYYYMMDD" do
      y = year.to_s.rjust(4, "0")
      m = month.to_s.rjust(2, "0")
      d = day.to_s.rjust(2, "0")
      expect(expiration.iso8601).to eq (y + m + d)
      expect(expiration.iso8601.size).to eq 8
    end
  end
end
