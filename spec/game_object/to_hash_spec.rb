require "spec_helper"

describe GameObject, "#to_hash" do
  context "given a typical game object" do
    let(:tracked_bot) { TrackedBot.new :position => Point(128, 256), :angle => 180.degrees }

    subject { tracked_bot.to_hash }

    it "should contain all properties" do
      subject[:position].should == [128, 256]
      subject[:angle].should == Math::PI
    end

    it "should contain a type" do
      subject[:type].should == "tracked_bot"
    end

    it "should contain a unique id" do
      subject[:id].should == tracked_bot.id
    end

    it "should contain all children" # :player => [:factory, :bot => [:angle, :track]
  end
end
