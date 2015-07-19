require 'spec_helper'

describe Engineer, '#directed_towards?' do
  let(:facility) { MetalDerrick.new position: Point(0, 0) }

  subject { bot.directed_towards?(facility) }

  context 'when bot is directed exactly towards facility' do
    let(:bot) { Engineer.new position: Point(-10, -10), angle: 45.degrees }

    it { is_expected.to be true }
  end

  context 'when bot is directed within 1 degree towards facility' do
    let(:bot) { Engineer.new position: Point(10, 0), angle: 180.9.degrees }

    it { is_expected.to be true }
  end

  context 'when bot is directed elsewhere' do
    let(:bot) { Engineer.new position: Point(10, 0), angle: 190.degrees }

    it { is_expected.to be false }
  end

  context 'when bot is directed towards opposite side' do
    let(:bot) { Engineer.new position: Point(10, 0), angle: 0.degrees }

    it { is_expected.to be false }
  end
end
