$: << File.expand_path(File.join(__dir__, "..", "..", "..")) # useful when this file is directly required by other gems
require_relative "shared_product_spec"
require_relative "shared_quote_spec"

RSpec.shared_examples "legs interface with required methods" do |parent_module|
  parent_module::Interface.required_methods.each do |rm|
    it "implements expected interface method :#{rm}" do
      expect(container).to respond_to(rm)
    end
  end

  # Legs shouldn't respond to Product or Quote... that happens at the Leg level
  # But need a way for these tests to be enforced against Leg interface inside Legs
  # ....
  # include_examples "product interface with required methods", TTK::Containers::Product
  # include_examples "quote interface with required methods", TTK::Containers::Quote

  # Type check...

  describe "#opening" do
    it "returns a boolean" do
      expect(container.opening?).to eq(true).or(eq(false))
    end
  end

  describe "#closing" do
    it "returns a boolean" do
      expect(container.closing?).to eq(true).or(eq(false))
    end
  end

  # # Order only
  # describe "#rolling?" do
  #   it "returns a boolean" do
  #     expect(container.rolling?).to eq(true).or(eq(false))
  #   end
  # end

  describe "#action" do
    before do
      # this stub kind of defeats the purpose of this test
      # but there's no simple way to set this up to get a "real" result
      allow(TTK::Containers::Legs::Classifier::Action).to receive(:classify).and_return(:none)
    end

    it "returns a Symbol" do
      expect(container.action).to be_kind_of(Symbol)
    end
  end

  describe "#order_type" do
    before do
      # this stub kind of defeats the purpose of this test
      # but there's no simple way to set this up to get a "real" result
      allow(TTK::Containers::Legs::Classifier::Combo).to receive(:classify).and_return(:none)
    end

    it "returns a Symbol" do
      expect(container.order_type).to be_kind_of(Symbol)
    end
  end
end

RSpec.shared_examples "legs interface - 4-leg order roll out" do
  describe "#opening" do
    it "returns true" do
      expect(container.opening?).to eq true
    end
  end

  describe "#closing" do
    it "returns true" do
      expect(container.closing?).to eq true
    end
  end

  describe "#rolling" do
    it "returns true" do
      expect(container.rolling?).to eq true
    end
  end

  describe "#action" do
    it "returns :roll_out" do
      expect(container.action).to eq :roll_out
    end
  end

  describe "#order_type" do
    it "returns :spread_diagonal_roll" do
      expect(container.order_type).to eq :spread_diagonal_roll
    end
  end
end

RSpec.shared_examples "legs interface - 4-leg order roll in" do
  describe "#opening" do
    it "returns true" do
      expect(container.opening?).to eq true
    end
  end

  describe "#closing" do
    it "returns true" do
      expect(container.closing?).to eq true
    end
  end

  describe "#rolling" do
    it "returns true" do
      expect(container.rolling?).to eq true
    end
  end

  describe "#action" do
    it "returns :roll_in" do
      expect(container.action).to eq :roll_in
    end
  end

  describe "#order_type" do
    it "returns :spread_diagonal_roll" do
      expect(container.order_type).to eq :spread_diagonal_roll
    end
  end
end

RSpec.shared_examples "legs interface - basic behavior" do
  describe "#market_session" do
    context "when regular session" do
      it "returns :regular" do
        expect(container.market_session).to eq :regular
      end
    end

    context "when extended session" do
      let(:market_session) { :extended }

      it "returns :extended" do
        expect(container.market_session).to eq :extended
      end
    end
  end

  describe "#all_or_none" do
    context "when enabled" do
      let(:all_or_none) { true }
      it "returns true" do
        expect(container.all_or_none).to be true
      end
    end

    context "when disabled" do
      let(:all_or_none) { false }
      it "returns false" do
        expect(container.all_or_none).to be false
      end
    end
  end

  describe "#price_type" do
    context "when a net credit" do
      let(:price_type) { :credit }
      it "returns :credit" do
        expect(container.price_type).to eq :credit
      end
    end

    context "when a net debit" do
      let(:price_type) { :debit }
      it "returns :debit" do
        expect(container.price_type).to eq :debit
      end
    end

    context "when net even" do
      let(:price_type) { :even }
      it "returns :even" do
        expect(container.price_type).to eq :even
      end
    end
  end

  describe "#limit_price" do
    it "returns the price" do
      expect(container.limit_price).to eq limit_price
    end
  end

  describe "#stop_price" do
    it "returns the price" do
      expect(container.stop_price).to eq stop_price
    end
  end

  describe "#order_term" do
    context "when it is a GOOD FOR DAY order" do
      let(:order_term) { :day }
      it "returns :day" do
        expect(container.order_term).to eq :day
      end
    end

    context "when it is a GOOD UNTIL CANCEL order" do
      let(:order_term) { :gtc }
      it "returns :gtc" do
        expect(container.order_term).to eq :gtc
      end
    end
  end
end
