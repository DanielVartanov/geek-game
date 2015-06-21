require 'spec_helper'

describe TrackedBot, 'battery' do
  let(:bot) { PewPew.new }

  context 'when tracked bot is created' do
    it 'should have battery' do
      bot.should respond_to(:battery)
    end

    it 'should have full charge' do
      bot.battery.charge.should === 1.0
    end
  end

  context 'when bot moves' do
    context 'when one track moves' do
      it 'should be decreased according to tracks power'
    end

    context 'when both tracks move' do
      it 'should be decreased according to tracks power'
    end

    context 'when bot is stopped' do
      it 'should not be discharged at all'
    end
  end

  context 'when battery charge is too low' do
    it 'should be unable to move'

    it 'should be unable to fire'
  end

  context 'when battery is completely dicharged while moving' do
    it 'should stop slowly according to tracks acceleration'
  end
end
