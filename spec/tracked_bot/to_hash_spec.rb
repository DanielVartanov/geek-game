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

  it "should contain track positions" do
    subject[:left_track_position_coordinates].should == bot.left_track_position.to_array
    subject[:right_track_position_coordinates].should == bot.right_track_position.to_array
  end

  it "should contain track powers" do
    subject[:left_track_power].should == bot.left_track.power
    subject[:right_track_power].should == bot.right_track.power
  end
end
