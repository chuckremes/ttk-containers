# frozen_string_literal: true

require "ttk/containers/rspec/shared_expiration_spec"

RSpec.describe TTK::Containers::Product::Expiration::Example do
  describe "creation" do
    let(:year) { 2021 }
    let(:month) { 12 }
    let(:day) { 11 }

    subject(:expiration) do
      described_class.new(year: year, month: month, day: day)
    end

    it "returns an expiration instance" do
      expect(expiration).to be_instance_of(described_class)
    end

    include_examples "expiration interface with required methods", TTK::Containers::Product::Expiration
  end

  describe "instance" do
    let(:year) { 2021 }
    let(:month) { 12 }
    let(:day) { 11 }

    include_examples "expiration interface with basic behaviors" do
      let(:expiration) do
        described_class.new(year: year, month: month, day: day)
      end
    end
  end
end
