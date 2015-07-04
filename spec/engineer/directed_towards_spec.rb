require 'spec_helper'

describe Engineer, '#directed_towards?' do
  let(:facility) { MetalDerrick.new position: Point(0, 0) }

  subject { bot.directed_towards?(facility) }

  context 'when bot is directed exactly towards facility' do
    let(:bot) { Engineer.new position: Point(-10, -10), angle: 45.degrees }

    it { is_expected.to be true }
  end

  context 'when bot is directed almost towads facility' do
    let(:bot) { Engineer.new position: Point(10, 0), angle: 181.degrees }

    it { is_expected.to be false }
  end

  context 'when bot is directed elsewhere' do
    let(:bot) { Engineer.new position: Point(10, 0), angle: 90.degrees }

    it { is_expected.to be false }
  end

  context 'when bot is directed towards opposite side' do
    let(:bot) { Engineer.new position: Point(10, 0), angle: 0.degrees }

    it { is_expected.to be false }
  end
end
