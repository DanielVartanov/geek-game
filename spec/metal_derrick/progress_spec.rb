require 'spec_helper'

describe MetalDerrick, '#progress' do
  let(:metal_derrick) { MetalDerrick.new position: Point(0, 0) }

  subject { metal_derrick.progress }

  context 'initially' do
    it { is_expected.to eq 0 }

    context 'when half of cooldown period passed' do
      before { metal_derrick.update(1.0) }

      it { is_expected.to eq 0.5 }

      context 'when 3/4 of cooldown period passed' do
        before { metal_derrick.update(0.5) }

        it { is_expected.to eq 0.75 }

        context 'when metal bars are available' do
          before { metal_derrick.update(0.5) }

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
