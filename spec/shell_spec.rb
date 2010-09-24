require "spec_helper"

describe Shell do
  describe "#update_position" do
    describe "when target angle is 45 degrees" do
      before do
        @angle = 45.degrees
        @shell = Shell.new :target_angle => @angle
      end

      describe "passed range is less than MAX_RANGE" do
        before do
          seconds = Shell::MAX_RANGE / (Shell::VELOCITY * 2)
          @shell.update_position(seconds)

          @expected_position = Vector(1, 0).rotate(@angle) * (Shell::VELOCITY * seconds)
        end
        
        it "should advance position according to the VELOCITY" do
          @shell.position.should === @expected_position
        end
      end

      describe "passed range is greater than MAX_RANGE" do
        before do
          seconds = (Shell::MAX_RANGE / Shell::VELOCITY) + 10
          @shell.update_position(seconds)

          @expected_position = Vector(1, 0).rotate(@angle) * Shell::MAX_RANGE
        end

        it "should advance position to the MAX_RANGE" do
          @shell.position.should === @expected_position
        end
      end
    end
  end

  describe "#died?" do
    describe "given a target_angle" do
      before do
        @angle = -45.degrees
        @shell = Shell.new :target_angle => @angle
      end

      describe "when passed range is less than MAX_RANGE" do
        before do
          seconds = Shell::MAX_RANGE / (Shell::VELOCITY * 2)
          @shell.update_position(seconds)
        end

        it "should return false" do
          @shell.died? === false
        end

      end

      describe "when passed range is greater than MAX_RANGE" do
        before do
          seconds = (Shell::MAX_RANGE / Shell::VELOCITY) * 2
          @shell.update_position(seconds)
        end

        it "should return true" do
          @shell.died?.should === true
        end
      end
    end
  end
end
