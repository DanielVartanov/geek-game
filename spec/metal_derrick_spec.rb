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
end
