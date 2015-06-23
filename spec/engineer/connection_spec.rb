require 'spec_helper'

describe Engineer, '#connection' do
  let(:facility) { MetalDerrick.new position: Point(0, 0) }
  let(:bot) { Engineer.new position: Point(10, 0), angle: 180.degrees }

  subject { bot.connection }

  context 'when connection established' do
    before { bot.connect_to facility }

    it { is_expected.not_to be nil }

    it { is_expected.to eq facility.connections.last }
  end

  context 'when connection is broken' do
    it 'is_expected.to be nil'
  end
end
