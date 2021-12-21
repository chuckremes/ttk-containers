# frozen_string_literal: true

require 'ttk/containers/rspec/shared_quote_spec'

module SpecialForTesting
  def set(key, value)
    h = {}
    h[key] = value
    h
  end
end

RSpec.describe TTK::Containers::Quote::Example do
  let(:quote_timestamp) { Time.now }
  let(:quote_status) { :realtime }
  let(:ask) { 17.15 }
  let(:bid) { 17.11 }
  let(:last) { 17.12 }
  let(:volume) { 12 }
  let(:dte) { 0 }
  let(:open_interest) { 14 }
  let(:intrinsic) { 1.0 }
  let(:extrinsic) { 1.0 }
  let(:multiplier) { 100 }
  let(:delta) { 1.0 }
  let(:theta) { 1.0 }
  let(:gamma) { 0.0 }
  let(:vega) { 1.0 }
  let(:rho) { 1.0 }
  let(:iv) { 1.0 }
  let(:product) { make_default_equity_product }

  subject(:container) do
    described_class.new(quote_timestamp: quote_timestamp,
                        quote_status: quote_status,
                        ask: ask,
                        bid: bid,
                        last: last,
                        volume: volume,
                        dte: dte,
                        open_interest: open_interest,
                        intrinsic: intrinsic,
                        extrinsic: extrinsic,
                        multiplier: multiplier,
                        delta: delta,
                        theta: theta,
                        gamma: gamma,
                        vega: vega,
                        rho: rho,
                        iv: iv,
                        product: product)
  end

  describe 'creation' do
    it 'returns a Quote instance' do
      expect(container).to be_instance_of(described_class)
    end

    include_examples 'quote interface - required methods', TTK::Containers::Quote
  end

  context 'equity' do
    let(:product) { make_default_equity_product }

    describe 'basic interface' do
      # quote_timestamp, quote_status, ask, bid, last, and volume must be defined for this to work
      include_examples 'quote interface - methods equity'
    end

    describe '#update_quote' do
      let(:security_type) { :equity_option }
      let(:update_object) { {} }

      before do
        update_object.extend(SpecialForTesting)
      end

      include_examples 'quote interface - update equity'
    end
  end

  context 'equity option' do
    let(:product) { make_default_equity_option_product }

    describe 'basic interface' do
      # quote_timestamp, quote_status, ask, bid, last, and volume must be defined for this to work
      # also requires delta, gamma, theta, vega, rho, iv, dte, open_interest, multiplier, intrinsic, and extrinsic
      include_examples 'quote interface - methods equity_option'
    end

    describe '#update_quote' do
      let(:security_type) { :equity_option }
      let(:update_object) { {} }

      before do
        update_object.extend(SpecialForTesting)
      end

      include_examples 'quote interface - update equity_option'
    end
  end
end
