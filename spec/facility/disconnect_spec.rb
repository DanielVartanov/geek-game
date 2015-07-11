require 'spec_helper'

describe Facility, '#disconnect' do
  let(:facility) { MetalDerrick.new position: Point(0, 0) }

  let(:first_bot) { Engineer.new position: Point(10, 0), angle: 180.degrees }
  let(:second_bot) { Engineer.new position: Point(10, 0), angle: 180.degrees }
  let(:third_bot) { Engineer.new position: Point(10, 0), angle: 180.degrees }

  before do
    [first_bot, second_bot, third_bot].each do |bot|
      bot.connect_to facility
    end
  end

  before { facility.disconnect(second_bot) }

  specify { expect(facility.connected_bots).to eq [first_bot, third_bot] }
end
