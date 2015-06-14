require 'spec_helper'

describe TrackedBot do
  let(:bot) { PewPew.new }

  describe 'tracks' do
    it "should set power to 0 at initialize" do
      bot.left_track.power.should === 0
      bot.right_track.power.should === 0
    end
  end

  describe "battery" do
    context "when tracked bot is created" do
      it "should have battery" do
        bot.should respond_to(:battery)
      end

      it "should have full charge" do
        bot.battery.charge.should === 1.0
      end
    end

    context "when bot moves" do
      context "when one track moves" do
        it "should be decreased according to tracks power" do
          pending
        end
      end

      context "when both tracks move" do
        it "should be decreased according to tracks power" do
          pending
        end
      end

      context "when bot is stopped" do
        it "should not be discharged at all" do
          pending
        end
      end
    end

    context "when battery charge is too low" do
      it "should be unable to move" do
        pending
      end

      it "should be unable to fire" do
        pending
      end
    end

    context "when battery is completely dicharged while moving" do
      it "should stop slowly according to tracks acceleration" do
        pending
      end
    end
  end

  describe "#take_damage" do
    context "given damage value is less than the current health points" do
      before do
        bot.take_damage bot.max_health_points / 3
      end

      it "should decrease health points according to the damage value" do
        bot.health_points.should === bot.max_health_points * 2 / 3
      end
    end

    context "given damage value is greater than the current health points" do
      before do
        bot.take_damage bot.max_health_points * 1.5
      end

      it "should set health points to 0" do
        bot.health_points.should === 0
      end
    end
  end

  describe "#to_hash" do
    subject { bot.to_hash }

    it "should contain common properties derived from Base" do
      [:angle, :position, :type, :id].each do |key|
        subject.key?(key).should be_true
      end
    end

    it "should contain all specific properties" do
      subject[:health_points].should == bot.health_points
    end

    it "should contain battery" do
      subject[:battery].should == bot.battery.to_hash
    end

    it "should contain tracks" do
      subject[:left_track].should == bot.left_track.to_hash
      subject[:right_track].should == bot.right_track.to_hash
    end
  end
end
