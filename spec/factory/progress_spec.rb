require 'spec_helper'

describe Factory, '#progress' do
  let(:factory) { EngineerFactory.new position: Point(0, 0) }

  subject { factory.progress }

  context 'when factory is producing' do
    before { factory.receive_metal_bars(5) }

    context 'in the beginning' do
      it { is_expected.to eq 0 }

      context 'when a half of production time passed' do
        before { update(2.5) }

        it { is_expected.to be_within(0.05).of(0.5) }

        context 'when 80% of production time passed' do
          before { update(1.5) }

          it { is_expected.to be_within(0.05).of(0.8) }
        end
      end
    end
  end

  context 'when factory is not producing' do
    context 'no matter when' do
      before { update(1) }

      it { is_expected.to eq 0 }
    end
  end
end
