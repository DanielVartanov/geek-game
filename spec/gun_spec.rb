require 'spec_helper'

describe Gun do
  let(:bot) { PewPew.new }
  let(:gun) { bot.gun }

  it "should set angle to 90 at initialize" do
    gun.angle.should === 90.degrees
  end

  describe "#rotate" do
    describe "when a target angle is far from current" do
      describe "when a given angle is > 0" do
        before do
          gun.rotate(90.degrees)
          gun.update_angle(1)
        end

        it "should advance current angle according to the angular velocity" do
          gun.angle.should === 180.degrees
        end
      end

      describe "when a given angle is < 0" do
        before do
          gun.rotate(-90.degrees)
          gun.update_angle(1)
        end

        it "should advance current angle according to the angular velocity" do
          gun.angle.should === 0.degrees
        end
      end

      describe "when passed time is too long" do
        before do
          gun.rotate(90.degrees)
          gun.update_angle(1000)
        end

        it "should advance current angle according to the angular velociry" do
          gun.angle.should === 180.degrees
        end
      end

      describe "when passed time is not enought to rich the target angle" do
        before do
          seconds = 0.5

          gun.rotate(180.degrees)
          gun.update_angle(seconds)

          @expected_angle = Vector(1,0).signed_angle_with(Vector(0,1).rotate(Gun::ANGULAR_VELOCITY * seconds))
        end

        it "should advance current angle according to the angular velocity" do
          gun.angle.should === @expected_angle
        end
      end
    end

    describe "when a target angle is close to current" do
      describe "when a given angle is > 0" do
        before do
          gun.rotate(1.degrees)
          gun.update_angle(1)
        end

        it "should advance current angle to the target angle" do
          gun.angle.should === 91.degrees
        end
      end

      describe "when a given angle is < 0" do
        before do
          gun.rotate(-4.degrees)
          gun.update_angle(1)
        end

        it "should advance current angle to the target angle" do
          gun.angle.should === 86.degrees
        end
      end
    end
  end

  describe "#absolute_angle" do
    subject { bot.gun.absolute_angle }

    describe "when bot angle is -45 degrees" do
      describe "when gun angle is 135 degrees" do
        let(:bot) { PewPew.new angle: -45.degrees, gun_relative_angle: 135.degrees }

        it "should return gun angle absolute value" do
          should === 90.degrees
        end
      end
    end
  end

  describe "#to_hash" do
    let(:bot) { PewPew.new }
    let(:gun) { bot.gun }

    subject { gun.to_hash }

    it { should == { :angle => gun.absolute_angle } }
  end
end
