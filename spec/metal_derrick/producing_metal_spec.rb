require 'spec_helper'

describe MetalDerrick, 'producing metal' do
  let(:metal_derrick) { MetalDerrick.new position: Point(0, 0) }

  subject { metal_derrick.metal_bars_available? }

  context 'initially' do
    it 'does not have any metal bars' do
      is_expected.to be false
    end

    context 'when less than 2 seconds passed' do
      before { metal_derrick.update(1.9) }

      it { is_expected.to be false }

      context 'when 2 seconds passed' do
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
