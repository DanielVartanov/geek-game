require 'spec_helper'

describe Engineer, '#connect_to' do
  let(:facility) { MetalDerrick.new position: Point(0, 0) }

  context 'when bot can connect to a facility' do
    let(:bot) { Engineer.new position: Point(10, 0), angle: 180.degrees }

    it 'creates a connection' do
      expect(bot.connect_to(facility)).not_to be_nil
    end

    context 'when called again' do
      context 'to the same facility' do
        it 'returns the same connection' do
          connection = bot.connect_to(facility)
          expect(bot.connect_to(facility)).to eq connection
        end
      end

      context 'to another facility' do
        let(:another_facility) { Recharger.new position: Point(0, 0) }

        it 'remains connected to previous facility until disconnected' do
          previous_connection = bot.connect_to(facility)
          expect(bot.connect_to(another_facility)).to eq previous_connection
        end
      end
    end
  end

  context 'when bot cannot connect to a facility' do
    it 'returns nil'
  end
end
