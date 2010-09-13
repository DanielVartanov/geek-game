__DIR__ = File.dirname(__FILE__)
require File.join(__DIR__, 'spec_helper')

describe Segment do
  describe "Segment()" do
    before :each do
      @segment = Segment(Point(1, 1), Point(2, 2))
    end

    it "should createSegment instance by two given points" do
      @segment.point1.should == Point(1, 1)
      @segment.point2.should == Point(2, 2)
    end
  end

  describe "#length" do
    it "should return length of the segment" do
      Segment(Point(0, 0), Point(1, 1)).length.should === Math.sqrt(2)
    end
  end

  describe "#middle_point" do
    it "should return middle point of the segment" do
      Segment(Point(1, 1), Point(3, 3)).middle_point.should == Point(2, 2)
    end
  end
end
