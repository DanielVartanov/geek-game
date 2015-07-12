require 'spec_helper'

describe Factory, 'receiving metal' do
  let(:pew_pew_factory) { PewPewFactory.new position: Point(0, 0) }

  context 'when engineer is connected' do
    let(:engineer) { Engineer.new position: Point(10, 0), angle: 180.degrees }

    context 'when engineer has metal bars' do
      before { engineer.take_metal }

      before { engineer.connect_to(pew_pew_factory) }

      context 'before 0.5 seconds since connection has passed' do
        before { update(0.4) }

        context 'when 0.5 seconds since connection has passed' do
          before { update(0.1) }

          specify 'engineer gives its metal' do
            expect(engineer.metal_bars_carried).to be false
            expect(pew_pew_factory.metal_bars_count).to eq 5
          end

          specify 'engineer is disconnected' do
            expect(engineer).not_to be_connected_to_facility
          end
        end

        context 'when engineer moves/turns away while being connected' do
          before { engineer.motor!(1, -1) }

          before { update(0.1) }

          specify 'engineer is disconnected' do
            expect(engineer).not_to be_connected_to_facility
          end

          specify 'engineer does not give its metal' do
            expect(engineer.metal_bars_carried).to be true
            expect(pew_pew_factory.metal_bars_count).to eq 0
          end
        end
      end
    end

    context 'when engineer does not have metal bars' do
      before { engineer.connect_to(pew_pew_factory) }

      context 'when 0.5 or more seconds since connection has passed' do
        before { update(1) }

        specify 'engineer does not give its metal' do
          expect(engineer.metal_bars_carried).to be false
          expect(pew_pew_factory.metal_bars_count).to eq 0
        end

        specify 'engineer is disconnected' do
          expect(engineer).not_to be_connected_to_facility
        end
      end
    end
  end

  context 'when several enginners are connected at the same time' do
    let!(:engineers) do
      5.times.map do
        Engineer.new position: Point(10, 0), angle: 180.degrees
      end.each do |engineer|
        engineer.take_metal
        engineer.connect_to pew_pew_factory
      end
    end

    context 'after 0.5 seconds' do
      before { update(0.5) }

      specify 'they all give their metal (15 are consumed immediately for production)' do
        engineers.each do |engineer|
          expect(engineer.metal_bars_carried).to eq false
        end

        expect(pew_pew_factory.metal_bars_count).to eq 10
      end

      specify 'they all are disconnected' do
        engineers.each do |engineer|
          expect(engineer).not_to be_connected_to_facility
        end
      end
    end
  end
end
