require "spec_helper"

describe GameObject, "#to_hash" do
  context "given a typical game object" do
    let(:bot) { PewPew.new position: Point(128, 256), angle: 180.degrees }

    subject { bot.to_hash }

    it "should contain all properties" do
      subject[:position].should == [128, 256]
      subject[:angle].should == Math::PI
    end

    it "should contain a type" do
      subject[:type].should == "pew_pew"
    end

    it "should contain a unique id of the object" do
      subject[:id].should == bot.id
    end
  end
end
