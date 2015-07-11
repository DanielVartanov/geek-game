require 'spec_helper'

describe MetalDerrick, 'giving metal' do
  let!(:metal_derrick) { MetalDerrick.new position: Point(0, 0) }

  shared_examples 'metal is given' do
    specify { expect(metal_derrick.metal_bars_available?).to be false }
    specify { expect(engineer.metal_bars_carried?).to be true }

    it 'closes connection' do
      expect(engineer).not_to be_connected_to_facility
      expect(metal_derrick.connected_bots).not_to include(engineer)
    end
  end

  context 'when metal is produced already' do
    before { update(10) }

    context 'when an engineer connects to the derrick' do
      let(:engineer) { Engineer.new position: Point(10, 0), angle: 180.degrees }

      before { engineer.connect_to(metal_derrick) }

      specify { expect(metal_derrick.metal_bars_available?).to be true }
      specify { expect(engineer.metal_bars_carried?).to be false }

      context 'before 0.5 seconds after connection' do
        before { update(0.45) }

        specify { expect(metal_derrick.metal_bars_available?).to be true }
        specify { expect(engineer.metal_bars_carried?).to be false }

        context 'after 0.5 seconds' do
          before { update(0.1) }

          include_examples 'metal is given'
        end

        context 'if connection is broken' do
          before { engineer.disconnect }

          specify { expect(metal_derrick.metal_bars_available?).to be true }
          specify { expect(engineer.metal_bars_carried?).to be false }

          context 'when more time pass' do
            before { update(10) }

            specify { expect(metal_derrick.metal_bars_available?).to be true }
            specify { expect(engineer.metal_bars_carried?).to be false }
          end
        end
      end
    end
  end

  context 'when an engineer connects to the derrick far before metal is ready' do
    let(:engineer) { Engineer.new position: Point(10, 0), angle: 180.degrees }

    before { engineer.connect_to(metal_derrick) }

    specify { expect(metal_derrick.metal_bars_available?).to be false }
    specify { expect(engineer.metal_bars_carried?).to be false }

    context 'when metal becomes ready' do
      before { update(2.0) }

      include_examples 'metal is given'
    end
  end

  context 'when engineer connects to the derrick shortly before metal is produced' do
    before { update(1.75) }

    let(:engineer) { Engineer.new position: Point(10, 0), angle: 180.degrees }

    before { engineer.connect_to(metal_derrick) }

    specify { expect(metal_derrick.metal_bars_available?).to be false }
    specify { expect(engineer.metal_bars_carried?).to be false }

    context 'when metal is produced' do
      before { update(0.25) }

      specify { expect(metal_derrick.metal_bars_available?).to be true }
      specify { expect(engineer.metal_bars_carried?).to be false }

      context 'when 0.5 seconds since engineer is connected' do
        before { update(0.25) }

        include_examples 'metal is given'
      end
    end
  end

  context 'when several engineers connect to the derrick' do
    let(:first_engineer) { Engineer.new position: Point(10, 0), angle: 180.degrees }
    let(:second_engineer) { Engineer.new position: Point(10, 0), angle: 180.degrees }
    let(:third_engineer) { Engineer.new position: Point(10, 0), angle: 180.degrees }

    before do
      [first_engineer, second_engineer, third_engineer].each do |engineer|
        engineer.connect_to metal_derrick
      end
    end

    context 'when 2 seconds passed' do
      before { update(2.0) }

      specify { expect(metal_derrick.metal_bars_available?).to be false }
      specify { expect(first_engineer.metal_bars_carried?).to be true }
      specify { expect(second_engineer.metal_bars_carried?).to be false }
      specify { expect(third_engineer.metal_bars_carried?).to be false }
      specify { expect(metal_derrick.connected_bots).to eq [second_engineer, third_engineer] }

      context 'when another 2 seconds passed' do
        before { update(2.0) }

        specify { expect(metal_derrick.metal_bars_available?).to be false }
        specify { expect(first_engineer.metal_bars_carried?).to be true }
        specify { expect(second_engineer.metal_bars_carried?).to be true }
        specify { expect(third_engineer.metal_bars_carried?).to be false }
        specify { expect(metal_derrick.connected_bots).to eq [third_engineer] }
      end
    end
  end
end
