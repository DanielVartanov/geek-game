require 'spec_helper'

describe TrackedBot, 'tracks' do
  let(:bot) { PewPew.new }

  it 'should set power to 0 at initialize' do
    bot.left_track.power.should === 0
    bot.right_track.power.should === 0
  end
end
