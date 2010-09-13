__DIR__ = File.dirname(__FILE__)
require File.join(__DIR__, 'spec_helper')

describe Numeric, "#degreed" do
  context "when number is Float" do
    it "should convert radians to degrees" do
      180.to_f.degrees.should === Math::PI
    end
  end

  context "when number is Fixnum" do
    it "should convert radians to degrees" do
      90.degrees.should == Math::PI / 2
    end
  end
end
