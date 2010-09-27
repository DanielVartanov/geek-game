require "spec_helper"

describe Shell do
  describe "#update" do
    describe "when target angle is 45 degrees" do
      before do
        @angle = 45.degrees
        @shell = Shell.new :angle => @angle
      end

      describe "passed range is less than MAX_RANGE" do
        before do
          @seconds = Shell::MAX_RANGE.to_f / (Shell::VELOCITY * 2)
          @shell.update(@seconds)
        end

        it "should advance position according to the VELOCITY" do
          expected_position = Vector(1, 0).rotate(@angle) * (Shell::VELOCITY * @seconds)
          @shell.position.should === expected_position.to_point
        end
      end
    end
  end

  describe "#max_range_reached?" do
    before { @shell = Shell.new }

    subject { @shell.max_range_reached? }

    context "when flight range is lower than max range" do
      before do
        @shell.update(0.1)
      end
      
      it { should be_false }
    end

    context "when flight range is greater than max range" do
      before do
        @shell.update(1e3)
      end

      it { should be_true }
    end
  end

  describe "#hit?" do
    before { @bot = TrackedBot.new :position => Point(0, 0) }

    subject { @shell.hit?(@bot) }

    context "when shell is within track axis diameter" do
      before { @shell = Shell.new :position => Point(10, 10) }
      
      it { should be_true }
    end

    context "when shell is outside bot bounds" do
      before { @shell = Shell.new :position => Point(100, 100) }

      it { should be_false }
    end

    context "when shell is right at the bound of bot" do
      before { @shell = Shell.new :position => Point(0, TrackedBot::AXIS_LENGTH.to_f / 2) }

      it { should be_true }
    end
  end
end
