require 'spec_helper'

describe TrackedBot, '#to_hash' do
  let(:bot) { PewPew.new }

  subject { bot.to_hash }

  it "should contain common properties derived from Base" do
    [:angle, :position, :type, :id].each do |key|
      expect(subject.key?(key)).to be true
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
