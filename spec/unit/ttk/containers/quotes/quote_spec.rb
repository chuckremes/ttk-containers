require 'ttk/containers/rspec/shared_quote_spec'

RSpec.describe TTK::Containers::Quotes::Quote::Example do
  let(:quote_ts) { Time.now }
  let(:quote_status) { :realtime }
  let(:ask) { 17.15 }
  let(:bid) { 17.11 }
  let(:last) { 17.12 }
  let(:volume) { 12 }
  let(:dte) { 0 }
  let(:open_interest) { 14 }
  let(:intrinsic) { 0 }
  let(:extrinsic) { 0 }
  let(:multiplier) { 1 }
  let(:delta) { 0 }
  let(:theta) { 0 }
  let(:gamma) { 0 }
  let(:vega) { 0 }
  let(:rho) { 0 }
  let(:iv) { 0 }

  subject(:quote) do
    described_class.new(    quote_timestamp: quote_ts,
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
                            iv: iv
    )
  end

  describe 'creation' do
    it 'returns a quote instance' do
      expect(quote).to be_instance_of(described_class)
    end

    include_examples 'quote interface - required methods', TTK::Containers::Quotes::Quote
  end

  # describe 'call option' do
  #   let(:callput) { :call }
  #
  #   include_examples 'product interface - call'
  # end
  #
  # describe 'put option' do
  #   let(:callput) { :put }
  #
  #   include_examples 'product interface - put'
  # end
  #
  # describe 'equity' do
  #   let(:security_type) { :equity }
  #
  #   include_examples 'product interface - equity'
  # end
end
