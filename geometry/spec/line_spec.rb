__DIR__ = File.dirname(__FILE__)
require File.join(__DIR__, 'spec_helper')

describe Line do
  describe "Line()" do
    before :each do
      @line = Line(Point(1, 1), Point(2, 2))
    end

    it "should create Line instance by two given points" do
      @line.point1.should == Point(1, 1)
      @line.point2.should == Point(2, 2)
    end
  end
  
  describe "#intersection_point_with" do
    it "should calculate intersection point of two lines" do
      @first_line = Line(Point(-1, -1), Point(1, 1))
      @second_line = Line(Point(4, 0), Point(0, 4))
      @first_line.intersection_point_with(@second_line).should == Point(2, 2)
    end

    # TODO: overlapping case
    # TODO: parallel lines case
  end
end
