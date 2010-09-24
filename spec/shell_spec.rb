require "spec_helper"

describe Shell do
  describe "#update_position" do
    describe "when initail angle is 0" do
      before do
        @shell = Shell.new :position => Point(0, 0), :target_angle => 0.degrees
      end

      describe "when 1 second passed" do
        before do
          seconds = 1
          @shell.update_position(seconds)
          
          @expected_position = Vector(1, 0) * (Shell::VELOCITY * seconds)
        end

        it "should advance position according to the VELOCITY" do
          @shell.position.should == @expected_position
        end
      end

      describe "when 0.5 seconds passed" do
        before do
          seconds = 0.5
          @shell.update_position(seconds)
          
          @expected_position = Vector(1, 0) * (Shell::VELOCITY * seconds)
        end
        
        it "should advance position according to the VELOCITY" do
          @shell.position.should == @expected_position          
        end
      end

      describe "when 2 seconds passed" do
        before do
          seconds = 2
          @shell.update_position(seconds)
          
          @expected_position = Vector(1, 0) * (Shell::VELOCITY * seconds)
        end
        
        it "should advance position according to the VELOCITY" do
          @shell.position.should == @expected_position
        end        
      end
    end

    describe "when inistal angle is 45 degrees" do
      before do
        @shell = Shell.new :position => Point(0, 0), :target_angle => 45.degrees
      end

      describe "when 1 second passed" do
        before do
          seconds = 1
          @shell.update_position(seconds)
          
          @expected_position = Vector(1, 0).rotate(45.degrees) * (Shell::VELOCITY * seconds)
        end

        it "should advance position according to the VELOCITY" do
          @shell.position.should == @expected_position
        end
      end

      describe "when 0.5 seconds passed" do
        before do
          seconds = 0.5
          @shell.update_position(seconds)
          
          @expected_position = Vector(1, 0).rotate(45.degrees) * (Shell::VELOCITY * seconds)
        end
        
        it "should advance position according to the VELOCITY" do
          @shell.position.should == @expected_position          
        end
      end

      describe "when 2 seconds passed" do
        before do
          seconds = 2
          @shell.update_position(seconds)
          
          @expected_position = Vector(1, 0).rotate(45.degrees) * (Shell::VELOCITY * seconds)
        end
        
        it "should advance position according to the VELOCITY" do
          @shell.position.should == @expected_position
        end        
      end
    end
  end
end
