require 'spec_helper'

describe Engineer, '#connected_to_facility?' do
  let(:facility) { MetalDerrick.new position: Point(0, 0) }
  let(:bot) { Engineer.new position: Point(10, 0), angle: 180.degrees }

  subject { bot.connected_to_facility? }

  context 'when bot is connected to a faclity' do
    before { bot.connect_to facility }

    it { is_expected.to be true }
  end

  context 'when bot is not connected to any facility' do
    it { is_expected.to be false }
  end
end
