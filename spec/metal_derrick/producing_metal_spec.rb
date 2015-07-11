require 'spec_helper'

describe MetalDerrick, 'producing metal' do
  let!(:metal_derrick) { MetalDerrick.new position: Point(0, 0) }

  subject { metal_derrick.metal_bars_available? }

  context 'initially' do
    it 'does not have any metal bars' do
      is_expected.to be false
    end

    context 'when less than 2 seconds passed' do
      before { update(1.9) }

      it { is_expected.to be false }

      context 'when 2 seconds passed' do
        before { update(0.1) }

        it { is_expected.to be true }

        context 'when more time passes' do
          before { update(10) }

          specify 'nothing is changed' do
            is_expected.to be true
          end

          context 'when metal is taken' do
            let(:engineer) { Engineer.new position: Point(10, 0), angle: 180.degrees }

            before { engineer.connect_to metal_derrick }

            before { update(0.5) }

            it { is_expected.to be false }

            context 'when less than 2 seconds passed after that' do
              before { update(1.9) }

              it { is_expected.to be false }

              context 'when 2 seconds passed' do
                before { update(0.1) }

                it { is_expected.to be true }
              end
            end
          end
        end
      end
    end
  end
end
