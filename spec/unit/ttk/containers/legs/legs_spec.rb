# frozen_string_literal: true

require 'ttk/containers/rspec/shared_legs_spec'

RSpec.describe TTK::Containers::Legs::Position::Example do
  subject(:container) do
    described_class.from_legs(
      legs: legs,
      status: status
    )
  end

  context 'where it is a 1-leg put position container' do
    let(:leg1) do
      make_option_leg(callput: callput, side: side1, direction: direction1, strike: strike1, last: last1,
                      underlying_last: underlying_last, expiration_date: expiration1)
    end
    let(:legs) { [leg1] }
    let(:callput) { :put }
    let(:last1) { 2.0 }
    let(:underlying_last) { 148.18 }
    let(:status) { :open }
    let(:expiration1) { nil }

    context 'with a short put' do
      let(:side1) { :short }
      let(:strike1) { 150 }

      context 'and leg is opening' do
        let(:direction1) { :opening }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :sell_to_open' do
            expect(container.action).to eq :sell_to_open
          end
        end

        describe '#order_type' do
          context 'when it is an option leg' do
            it 'returns :equity_option' do
              expect(container.order_type).to eq :equity_option
            end
          end

          context 'when it is an equity leg' do
            let(:leg1) do
              make_equity_leg(side: side1, direction: direction1, underlying_last: underlying_last)
            end

            it 'returns :equity' do
              expect(container.order_type).to eq :equity
            end
          end
        end
      end

      context 'and leg is closing' do
        let(:direction1) { :closing }

        describe '#opening' do
          it 'returns false' do
            expect(container.opening?).to eq false
          end
        end

        describe '#action' do
          it 'returns :sell_to_close' do
            expect(container.action).to eq :sell_to_close
          end
        end

        describe '#order_type' do
          context 'when it is an option leg' do
            it 'returns :equity_option' do
              expect(container.order_type).to eq :equity_option
            end
          end

          context 'when it is an equity leg' do
            let(:leg1) do
              make_equity_leg(side: side1, direction: direction1, underlying_last: underlying_last)
            end

            it 'returns :equity' do
              expect(container.order_type).to eq :equity
            end
          end
        end
      end
    end

    context 'with a long put' do
      let(:side1) { :long }
      let(:strike1) { 150 }

      context 'and leg is opening' do
        let(:direction1) { :opening }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :buy_to_open' do
            expect(container.action).to eq :buy_to_open
          end
        end

        describe '#order_type' do
          context 'when it is an option leg' do
            it 'returns :equity_option' do
              expect(container.order_type).to eq :equity_option
            end
          end

          context 'when it is an equity leg' do
            let(:leg1) do
              make_equity_leg(side: side1, direction: direction1, underlying_last: underlying_last)
            end

            it 'returns :equity' do
              expect(container.order_type).to eq :equity
            end
          end
        end
      end

      context 'and leg is closing' do
        let(:direction1) { :closing }

        describe '#opening' do
          it 'returns false' do
            expect(container.opening?).to eq false
          end
        end

        describe '#action' do
          it 'returns :buy_to_close' do
            expect(container.action).to eq :buy_to_close
          end
        end

        describe '#order_type' do
          context 'when it is an option leg' do
            it 'returns :equity_option' do
              expect(container.order_type).to eq :equity_option
            end
          end

          context 'when it is an equity leg' do
            let(:leg1) do
              make_equity_leg(side: side1, direction: direction1, underlying_last: underlying_last)
            end

            it 'returns :equity' do
              expect(container.order_type).to eq :equity
            end
          end
        end
      end
    end
  end

  context 'where it is a 2-leg put position container' do
    let(:leg1) do
      make_option_leg(callput: callput, side: side1, direction: direction1, strike: strike1, last: last1,
                      underlying_last: underlying_last, expiration_date: expiration1)
    end
    let(:leg2) do
      make_option_leg(callput: callput, side: side2, direction: direction2, strike: strike2, last: last2,
                      underlying_last: underlying_last, expiration_date: expiration2)
    end
    let(:legs) { [leg1, leg2] }
    let(:callput) { :put }
    let(:last1) { 2.0 }
    let(:last2) { 1.1 }
    let(:underlying_last) { 148.18 }
    let(:status) { :open }
    let(:expiration1) { nil }
    let(:expiration2) { nil }

    context 'with a short vertical put spread' do
      let(:side1) { :short }
      let(:side2) { :long }
      let(:strike1) { 150 }
      let(:strike2) { 140 }

      context 'and legs are opening' do
        let(:direction1) { :opening }
        let(:direction2) { :opening }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :sell_to_open' do
            expect(container.action).to eq :sell_to_open
          end
        end

        describe '#order_type' do
          context 'when it is an option leg' do
            it 'returns :vertical' do
              expect(container.order_type).to eq :vertical
            end
          end

          context 'when it is an equity leg' do
            let(:leg1) do
              make_equity_leg(side: side1, direction: direction1, underlying_last: underlying_last)
            end

            context 'and option leg is long' do
              it 'raises UnknownComboStructure' do
                expect { container.order_type }.to raise_error(TTK::Containers::Legs::Classifier::Combo::UnknownComboStructure)
              end
            end

            context 'and option leg is short' do
              let(:side2) { :short }
              it 'returns :covered' do
                expect(container.order_type).to eq :covered
              end
            end
          end
        end
      end

      context 'and legs are closing' do
        let(:direction1) { :closing }
        let(:direction2) { :closing }

        describe '#opening' do
          it 'returns false' do
            expect(container.opening?).to eq false
          end
        end

        describe '#action' do
          it 'returns :sell_to_close' do
            expect(container.action).to eq :sell_to_close
          end
        end
      end

      context 'and legs are mixed opening / closing' do
        let(:direction1) { :opening }
        let(:direction2) { :closing }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :roll' do
            expect(container.action).to eq :roll
          end
        end

        describe '#order_type' do
          context 'when it is an option leg' do
            it 'returns :vertical_roll' do
              expect(container.order_type).to eq :vertical_roll
            end
          end

          context 'when it is an equity leg' do
            let(:leg1) do
              make_equity_leg(side: side1, direction: direction1, underlying_last: underlying_last)
            end

            context 'and option leg is long' do
              it 'raises UnknownComboStructure' do
                expect { container.order_type }.to raise_error(TTK::Containers::Legs::Classifier::Combo::UnknownComboStructure)
              end
            end

            context 'and option leg is short' do
              let(:side2) { :short }
              it 'returns :covered' do
                expect(container.order_type).to eq :covered
              end
            end
          end
        end
      end
    end

    context 'with a long vertical put spread' do
      let(:side1) { :long }
      let(:side2) { :short }
      let(:strike1) { 150 }
      let(:strike2) { 140 }

      context 'and legs are opening' do
        let(:direction1) { :opening }
        let(:direction2) { :opening }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :buy_to_open' do
            expect(container.action).to eq :buy_to_open
          end
        end

        describe '#order_type' do
          it 'returns :vertical' do
            expect(container.order_type).to eq :vertical
          end
        end
      end

      context 'and legs are closing' do
        let(:direction1) { :closing }
        let(:direction2) { :closing }

        describe '#opening' do
          it 'returns false' do
            expect(container.opening?).to eq false
          end
        end

        describe '#action' do
          it 'returns :buy_to_close' do
            expect(container.action).to eq :buy_to_close
          end
        end

        describe '#order_type' do
          it 'returns :vertical' do
            expect(container.order_type).to eq :vertical
          end
        end
      end

      context 'and legs are mixed opening / closing' do
        let(:direction1) { :opening }
        let(:direction2) { :closing }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :roll' do
            expect(container.action).to eq :roll
          end
        end

        describe '#order_type' do
          it 'returns :vertical_roll' do
            expect(container.order_type).to eq :vertical_roll
          end
        end
      end
    end

    context 'with a calendar put spread' do
      let(:side1) { :short }
      let(:side2) { :long }
      let(:strike1) { 150 }
      let(:strike2) { 150 }
      let(:date1) { Date.today }
      let(:date2) { date1 + 30 }
      let(:expiration1) { make_expiration(year: date1.year, month: date1.month, day: date1.day) }
      let(:expiration2) { make_expiration(year: date2.year, month: date2.month, day: date2.day) }

      context 'and legs are opening' do
        let(:direction1) { :opening }
        let(:direction2) { :opening }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :sell_to_open' do
            expect(container.action).to eq :sell_to_open
          end
        end

        describe '#order_type' do
          it 'returns :calendar' do
            expect(container.order_type).to eq :calendar
          end
        end
      end

      context 'and legs are closing' do
        let(:direction1) { :closing }
        let(:direction2) { :closing }

        describe '#opening' do
          it 'returns false' do
            expect(container.opening?).to eq false
          end
        end

        describe '#action' do
          it 'returns :sell_to_close' do
            expect(container.action).to eq :sell_to_close
          end
        end

        describe '#order_type' do
          it 'returns :calendar' do
            expect(container.order_type).to eq :calendar
          end
        end
      end

      context 'and legs are mixed opening / closing' do
        let(:direction1) { :opening }
        let(:direction2) { :closing }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :roll_in' do
            expect(container.action).to eq :roll_in
          end
        end

        describe '#order_type' do
          it 'returns :calendar_roll' do
            expect(container.order_type).to eq :calendar_roll
          end
        end
      end

      context 'and legs are mixed closing / opening' do
        let(:direction1) { :closing }
        let(:direction2) { :opening }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :roll_out' do
            expect(container.action).to eq :roll_out
          end
        end

        describe '#order_type' do
          it 'returns :calendar_roll' do
            expect(container.order_type).to eq :calendar_roll
          end
        end
      end
    end

    context 'with a reverse calendar put spread' do
      let(:side1) { :long }
      let(:side2) { :short }
      let(:strike1) { 150 }
      let(:strike2) { 150 }
      let(:date1) { Date.today }
      let(:date2) { date1 + 30 }
      let(:expiration1) { make_expiration(year: date1.year, month: date1.month, day: date1.day) }
      let(:expiration2) { make_expiration(year: date2.year, month: date2.month, day: date2.day) }

      context 'and legs are opening' do
        let(:direction1) { :opening }
        let(:direction2) { :opening }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :buy_to_open' do
            expect(container.action).to eq :buy_to_open
          end
        end

        describe '#order_type' do
          it 'returns :calendar' do
            expect(container.order_type).to eq :calendar
          end
        end
      end

      context 'and legs are closing' do
        let(:direction1) { :closing }
        let(:direction2) { :closing }

        describe '#opening' do
          it 'returns false' do
            expect(container.opening?).to eq false
          end
        end

        describe '#action' do
          it 'returns :sell_to_close' do
            expect(container.action).to eq :buy_to_close
          end
        end

        describe '#order_type' do
          it 'returns :calendar' do
            expect(container.order_type).to eq :calendar
          end
        end
      end

      context 'and legs are mixed opening / closing' do
        let(:direction1) { :opening }
        let(:direction2) { :closing }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :roll_in' do
            expect(container.action).to eq :roll_in
          end
        end

        describe '#order_type' do
          it 'returns :calendar_roll' do
            expect(container.order_type).to eq :calendar_roll
          end
        end
      end

      context 'and legs are mixed closing / opening' do
        let(:direction1) { :closing }
        let(:direction2) { :opening }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :roll_out' do
            expect(container.action).to eq :roll_out
          end
        end

        describe '#order_type' do
          it 'returns :calendar_roll' do
            expect(container.order_type).to eq :calendar_roll
          end
        end
      end
    end

    context 'with a diagonal put spread' do
      let(:side1) { :short }
      let(:side2) { :long }
      let(:strike1) { 150 }
      let(:strike2) { 140 }
      let(:date1) { Date.today }
      let(:date2) { date1 + 30 }
      let(:expiration1) { make_expiration(year: date1.year, month: date1.month, day: date1.day) }
      let(:expiration2) { make_expiration(year: date2.year, month: date2.month, day: date2.day) }

      context 'and legs are opening' do
        let(:direction1) { :opening }
        let(:direction2) { :opening }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :sell_to_open' do
            expect(container.action).to eq :sell_to_open
          end
        end

        describe '#order_type' do
          it 'returns :diagonal' do
            expect(container.order_type).to eq :diagonal
          end
        end
      end

      context 'and legs are closing' do
        let(:direction1) { :closing }
        let(:direction2) { :closing }

        describe '#opening' do
          it 'returns false' do
            expect(container.opening?).to eq false
          end
        end

        describe '#action' do
          it 'returns :sell_to_close' do
            expect(container.action).to eq :sell_to_close
          end
        end

        describe '#order_type' do
          it 'returns :diagonal' do
            expect(container.order_type).to eq :diagonal
          end
        end
      end

      context 'and legs are mixed opening / closing' do
        let(:direction1) { :opening }
        let(:direction2) { :closing }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :roll_in' do
            expect(container.action).to eq :roll_in
          end
        end

        describe '#order_type' do
          it 'returns :diagonal_roll' do
            expect(container.order_type).to eq :diagonal_roll
          end
        end
      end

      context 'and legs are mixed closing / opening' do
        let(:direction1) { :closing }
        let(:direction2) { :opening }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :roll_out' do
            expect(container.action).to eq :roll_out
          end
        end

        describe '#order_type' do
          it 'returns :diagonal_roll' do
            expect(container.order_type).to eq :diagonal_roll
          end
        end
      end
    end

    context 'with a reverse diagonal put spread' do
      let(:side1) { :long }
      let(:side2) { :short }
      let(:strike1) { 150 }
      let(:strike2) { 140 }
      let(:date1) { Date.today }
      let(:date2) { date1 + 30 }
      let(:expiration1) { make_expiration(year: date1.year, month: date1.month, day: date1.day) }
      let(:expiration2) { make_expiration(year: date2.year, month: date2.month, day: date2.day) }

      context 'and legs are opening' do
        let(:direction1) { :opening }
        let(:direction2) { :opening }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :buy_to_open' do
            expect(container.action).to eq :buy_to_open
          end
        end

        describe '#order_type' do
          it 'returns :diagonal' do
            expect(container.order_type).to eq :diagonal
          end
        end
      end

      context 'and legs are closing' do
        let(:direction1) { :closing }
        let(:direction2) { :closing }

        describe '#opening' do
          it 'returns false' do
            expect(container.opening?).to eq false
          end
        end

        describe '#action' do
          it 'returns :sell_to_close' do
            expect(container.action).to eq :buy_to_close
          end
        end

        describe '#order_type' do
          it 'returns :diagonal' do
            expect(container.order_type).to eq :diagonal
          end
        end
      end

      context 'and legs are mixed opening / closing' do
        let(:direction1) { :opening }
        let(:direction2) { :closing }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :roll_in' do
            expect(container.action).to eq :roll_in
          end
        end

        describe '#order_type' do
          it 'returns :diagonal_roll' do
            expect(container.order_type).to eq :diagonal_roll
          end
        end
      end

      context 'and legs are mixed closing / opening' do
        let(:direction1) { :closing }
        let(:direction2) { :opening }

        describe '#opening' do
          it 'returns true' do
            expect(container.opening?).to eq true
          end
        end

        describe '#action' do
          it 'returns :roll_out' do
            expect(container.action).to eq :roll_out
          end
        end

        describe '#order_type' do
          it 'returns :diagonal_roll' do
            expect(container.order_type).to eq :diagonal_roll
          end
        end
      end
    end
  end
end

# RSpec.describe TTK::Containers::Legs::Order::Example do
#   subject(:container) do
#     described_class.from_legs(
#       legs: legs,
#       status: status,
#       market_session: market_session,
#       all_or_none: all_or_none,
#       price_type: price_type,
#       limit_price: limit_price,
#       stop_price: stop_price,
#       order_term: order_term
#     )
#   end
#   let(:market_session) { :regular }
#   let(:all_or_none) { false }
#   let(:price_type) { :debit }
#   let(:limit_price) { 0.0 }
#   let(:stop_price) { 0.0 }
#   let(:order_term) { :day }
#
#   context 'where it is a 1-leg put container' do
#     let(:leg1) do
#       make_option_leg(callput: callput, side: side1, direction: direction1, strike: strike1, last: last1,
#                       underlying_last: underlying_last, expiration_date: expiration1)
#     end
#     let(:legs) { [leg1] }
#     let(:callput) { :put }
#     let(:last1) { 2.0 }
#     let(:underlying_last) { 148.18 }
#     let(:status) { :open }
#     let(:expiration1) { nil }
#
#     context 'with a short put' do
#       let(:side1) { :short }
#       let(:strike1) { 150 }
#
#       context 'and leg is opening' do
#         let(:direction1) { :opening }
#
#         describe '#opening' do
#           it 'returns true' do
#             expect(container.opening?).to eq true
#           end
#         end
#
#         describe '#action' do
#           it 'returns :sell_to_open' do
#             expect(container.action).to eq :sell_to_open
#           end
#         end
#       end
#
#       context 'and leg is closing' do
#         let(:direction1) { :closing }
#
#         describe '#opening' do
#           it 'returns false' do
#             expect(container.opening?).to eq false
#           end
#         end
#
#         describe '#action' do
#           it 'returns :sell_to_close' do
#             expect(container.action).to eq :sell_to_close
#           end
#         end
#       end
#     end
#
#     context 'with a long put' do
#       let(:side1) { :long }
#       let(:strike1) { 150 }
#
#       context 'and leg is opening' do
#         let(:direction1) { :opening }
#
#         describe '#opening' do
#           it 'returns true' do
#             expect(container.opening?).to eq true
#           end
#         end
#
#         describe '#action' do
#           it 'returns :buy_to_open' do
#             expect(container.action).to eq :buy_to_open
#           end
#         end
#       end
#
#       context 'and leg is closing' do
#         let(:direction1) { :closing }
#
#         describe '#opening' do
#           it 'returns false' do
#             expect(container.opening?).to eq false
#           end
#         end
#
#         describe '#action' do
#           it 'returns :buy_to_close' do
#             expect(container.action).to eq :buy_to_close
#           end
#         end
#       end
#     end
#
#     # this is unique to orders... we do not have 4-leg position containers because we do
#     # not mix puts and calls (yet?)
#     context 'where it is a 4-leg order container' do
#     end
#
#   end
# end
