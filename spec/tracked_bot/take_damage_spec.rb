require 'spec_helper'

describe TrackedBot, '#take_damage' do
  let(:bot) { PewPew.new }

  context 'given damage value is less than the current health points' do
    before do
      bot.take_damage bot.max_health_points / 3
    end

    it 'should decrease health points according to the damage value' do
      bot.health_points.should === bot.max_health_points * 2 / 3
    end
  end

  context 'given damage value is greater than the current health points' do
    before do
      bot.take_damage bot.max_health_points * 1.5
    end

    it 'should set health points to 0' do
      bot.health_points.should === 0
    end
  end
end
