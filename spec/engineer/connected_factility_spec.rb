require 'spec_helper'

describe Engineer, '#connected_facility' do
  let(:facility) { MetalDerrick.new position: Point(0, 0) }
  let(:bot) { Engineer.new position: Point(10, 0), angle: 180.degrees }

  subject { bot.connected_facility }

  context 'when the bot is connected to a facility' do
    before { bot.connect_to(facility) }

    it { is_expected.to eq facility }
  end

  context 'when the bot is not connected' do
    it { is_expected.to be nil }
  end
end
