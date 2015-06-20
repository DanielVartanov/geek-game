require 'spec_helper'

describe MetalDerrick do
  let(:metal_derrick) { MetalDerrick.new position: Point(0, 0) }

  describe '#metal_bars_available' do
    subject { metal_derrick.metal_bars_available? }

    context 'initially' do
      it 'does not have any metal bars' do
        is_expected.to be false
      end

      context 'when less than 3 seconds passed' do
        before { metal_derrick.update(2.9) }

        it { is_expected.to be false }

        context 'when 3 seconds passed' do
          before { metal_derrick.update(0.1) }

          it { is_expected.to be true }

          context 'when more time passes' do
            before { metal_derrick.update(10) }

            specify 'nothing is changed' do
              is_expected.to be true
            end
          end
        end
      end
    end
  end

  describe '#progress' do
    subject { metal_derrick.progress }

    context 'initially' do
      it { is_expected.to eq 0 }

      context 'when half of cooldown period passed' do
        before { metal_derrick.update(1.5) }

        it { is_expected.to eq 0.5 }

        context 'when 3/4 of cooldown period passed' do
          before { metal_derrick.update(0.75) }

          it { is_expected.to eq 0.75 }

          context 'when metal bars are available' do
            before { metal_derrick.update(0.75) }

            it { is_expected.to eq 1.0 }

            context 'when more time passed' do
              before { metal_derrick.update(10) }

              specify 'nothing changes' do
                is_expected.to eq 1.0
              end
            end
          end
        end
      end
    end
  end
end
