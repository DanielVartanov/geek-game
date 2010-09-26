require 'spec_helper'

describe Track do
  before :each do
    @bot = TrackedBot.new
    @track = Track.new
  end

  it "should set power to 0 at initialize" do
    @track.power.should === 0
  end

  describe "#udpate_power" do
    describe "when target power is far from current" do
      describe "when target power is greater than current" do
        before :each do          
          @track.target_power = Track::TRACK_POWER_ACCELERATION * 2
          @track.update_power(1)
        end

        it "should advance power according to acceleration" do
          @track.power.should === Track::TRACK_POWER_ACCELERATION
        end
      end

      describe "when target power is lesser than current" do
        before :each do          
          @track.target_power = -(Track::TRACK_POWER_ACCELERATION * 2)
          @track.update_power(1)
        end

        it "should advance power according to acceleration" do
          @track.power.should === -(Track::TRACK_POWER_ACCELERATION)
        end
      end

      describe "when passed time is long too" do
        before :each do
          @track.target_power = 2.5 * Track::TRACK_POWER_ACCELERATION
          @track.update_power(3)
        end

        it "should advance power to target one" do
          @track.power.should == 2.5 * Track::TRACK_POWER_ACCELERATION
        end
      end
    end

    describe "when target power is close to current" do
      before :each do
        @track.target_power = 0.5 * Track::TRACK_POWER_ACCELERATION
        @track.update_power(3)
      end

      it "should advance power to target one" do
        @track.power.should == 0.5 * Track::TRACK_POWER_ACCELERATION
      end
    end
  end

  describe "#aim" do
    
  end

  describe "#gun_angle" do
    before do
      @expected_gun_angle = @bot.angle + @bot.gun.angle
    end
    
    it "should return gun angle absolute value" do
      @bot.gun_angle.should === @expected_gun_angle
    end

    describe "when bot angle is -45 degrees" do
      describe "when gun angle is 135 degrees" do
        before do
          @bot = TrackedBot.new :angle => -45.degrees, :gun_relative_angle => 135.degrees
          @expected_gun_angle = 90.degrees
        end

        it "should return gun angle absolute value" do
          @bot.gun_angle.should === @expected_gun_angle
        end
      end
    end
  end

  describe "#can_shoot?" do
    # TimeCop is needed
  end

  describe "#barrel_ending" do
    
  end

  describe "#take_damage" do
    describe "given damage value is less than the current health points" do
      before do
        @initial_health_points = TrackedBot::MAX_HEALTH_POINTS
        @damage_value = @initial_health_points/2
        @bot.take_damage @damage_value
      end

      it "should decrease health points according to the damage value" do
        @bot.health_points.should === @initial_health_points - @damage_value
      end
    end

    describe "given damage value is greater than the current health points" do
      before do
        @damage_value = TrackedBot::MAX_HEALTH_POINTS * 1.5
        @bot.take_damage @damage_value
      end

      it "should set health points to 0" do
        @bot.health_points.should === 0
      end
    end
  end
end
