require 'spec_helper'

describe Facility, '#connections' do
  let(:facility) { MetalDerrick.new position: Point(0, 0) }

  subject { facility.connections }

  context 'when there is no connections' do
    it { is_expected.to eq [] }
  end

  context 'when there are connections' do
    let(:first_bot) { Engineer.new position: Point(10, 0), angle: 180.degrees }
    let(:second_bot) { Engineer.new position: Point(10, 0), angle: 180.degrees }

    before do
      second_bot.connect_to facility
      first_bot.connect_to facility
    end

    it { is_expected.to eq [second_bot.connection, first_bot.connection] }

    context 'when connection is closed' do
      before { first_bot.disconnect }

      it { is_expected.to eq [second_bot.connection] }
    end
  end
end
