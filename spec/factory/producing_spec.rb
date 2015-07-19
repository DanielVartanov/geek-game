require 'spec_helper'

describe Factory, 'producing' do
  let(:pew_pew_factory) { PewPewFactory.new position: Point(0, 0), angle: 45.degrees }

  shared_examples 'bot is produced' do
    let(:created_bot) { GeekGame.game_objects.bots.last }

    it 'creates one PewPew' do
      expect(GeekGame.game_objects.bots.count).to eq 1
      expect(created_bot).to be_a PewPew
    end

    specify 'bot is directed in an angle of factory orientation' do
      expect(created_bot.angle).to eq -45.degrees
    end
  end

  shared_examples 'bot is not produced' do
    specify 'no bots are created' do
      expect(GeekGame.game_objects.bots.count).to eq 0
    end

    specify 'production is not started' do
      expect(pew_pew_factory).not_to be_producing
    end
  end

  context 'when there is no metal' do
    context 'no matter how much time pass' do
      before { update(10) }

      include_examples 'bot is not produced'
    end
  end

  context 'when there is no enough metal' do
    before { pew_pew_factory.receive_metal_bars(10) }

    context 'no matter how much time pass' do
      before { update(10) }

      include_examples 'bot is not produced'
    end
  end

  context 'when there is enough metal' do
    before { update(1) }

    before { pew_pew_factory.receive_metal_bars(15) }

    it 'immediately consumes all metal bars and starts production' do
      update(1e-15)
      expect(pew_pew_factory.metal_bars_count).to eq 0
      expect(pew_pew_factory).to be_producing
    end

    context 'when less than 5 seconds passed since metal receiving' do
      before { update(4.9) }

      specify 'metal bars count remains the same' do
        expect(pew_pew_factory.metal_bars_count).to eq 0
      end

      specify 'no bots are created' do
        expect(GeekGame.game_objects.bots.count).to eq 0
      end

      context 'when 5 seconds since metal receiving have passed' do
        before { update(0.1) }

        specify 'metal bars count remains the same' do
          expect(pew_pew_factory.metal_bars_count).to eq 0
        end

        include_examples 'bot is produced'

        context 'after that' do
          before { update(1) }

          specify 'metal bars count remains the same' do
            expect(pew_pew_factory.metal_bars_count).to eq 0
          end

          specify 'no bot is being produced' do
            expect(pew_pew_factory).not_to be_producing
          end
        end
      end
    end
  end

  context 'when there is more than enough metal even for two bots' do
    before { update(1) }

    before { pew_pew_factory.receive_metal_bars(35) }

    it 'consumes 15 metal bars and starts production' do
      update(1e-15)
      expect(pew_pew_factory.metal_bars_count).to eq 20
      expect(pew_pew_factory).to be_producing
    end

    context 'when 5 seconds since metal receiving have passed' do
      before { update(5.0) }

      include_examples 'bot is produced'

      specify 'metal bars are consumed for the next bot' do
        expect(pew_pew_factory.metal_bars_count).to eq 5
      end

      it 'is producing' do
        expect(pew_pew_factory).to be_producing
      end

      context 'after another 5 seconds' do
        before { update(5.0) }

        it 'creates second bot' do
          expect(GeekGame.game_objects.bots.count).to eq 2
        end

        context 'after that' do
          before { update(1) }

          specify 'metal bars count remains the same' do
            expect(pew_pew_factory.metal_bars_count).to eq 5
          end

          specify 'no bot is being produced' do
            expect(pew_pew_factory).not_to be_producing
          end
        end
      end
    end
  end
end
