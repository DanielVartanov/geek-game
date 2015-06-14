require "spec_helper"

describe Track do
  let(:bot) { PewPew.new }
  let(:track) { bot.left_track }

  describe "#to_hash" do
    subject { track.to_hash }

    it { should == { power: track.power, position: track.position.to_array } }
  end

  describe "#udpate_power" do
    context "when target power is far from current" do
      context "when target power is greater than current" do
        before :each do
          track.target_power = Track::TRACK_POWER_ACCELERATION * 2
          track.update_power(1)
        end

        it "should advance power according to acceleration" do
          track.power.should === Track::TRACK_POWER_ACCELERATION
        end
      end

      context "when target power is lesser than current" do
        before :each do
          track.target_power = -(Track::TRACK_POWER_ACCELERATION * 2)
          track.update_power(1)
        end

        it "should advance power according to acceleration" do
          track.power.should === -(Track::TRACK_POWER_ACCELERATION)
        end
      end

      context "when passed time is long too" do
        before :each do
          track.target_power = 2.5 * Track::TRACK_POWER_ACCELERATION
          track.update_power(3)
        end

        it "should advance power to target one" do
          track.power.should == 2.5 * Track::TRACK_POWER_ACCELERATION
        end
      end
    end

    context "when target power is close to current" do
      before :each do
        track.target_power = 0.5 * Track::TRACK_POWER_ACCELERATION
        track.update_power(3)
      end

      it "should advance power to target one" do
        track.power.should == 0.5 * Track::TRACK_POWER_ACCELERATION
      end
    end
  end
end
