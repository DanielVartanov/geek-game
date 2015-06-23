require 'spec_helper'

describe Connection do
  let(:facility) { MetalDerrick.new position: Point(0, 0) }

  describe 'preconditions to connect' do
    context 'when bot is too far' do

    end

    context 'when bot is turned away' do

    end

    context 'when bot is close enough and turned towards factility' do

    end
  end

  context 'when a bot connects to a facility' do
    let(:bot) { Engineer.new position: Point(0, 10), angle: 180.degrees }
    let!(:connection) { bot.connect_to(facility) }

    subject { connection }

    it 'is created' do
      is_expected.not_to be_nil
    end

    it 'has references to both the bot and the facility' do
      expect(subject.bot).to eq bot
      expect(subject.facility).to eq facility
    end

    it 'is referenced by both the bot and the facility' do
      expect(bot.connected_facility).to eq facility
      expect(facility.connected_bots).to eq [bot]
    end

    context 'when time passes' do
      before do
        [bot, facility, connection].each do |object|
          object.update(100)
        end
      end

      it 'remains intact' do
        expect(bot.connection).to eq connection
      end
    end

    context 'when bot moves' do
      it 'disappears'
    end

    context 'when bot turns away' do
      it 'disappears'
    end
  end

  context 'when several bots are connected to factility' do
    specify 'facility forms a queue of bots'

    context 'when connection disappears' do
      specify 'the queue is shifted accordingly'
    end
  end
end
