__DIR__ = File.dirname(__FILE__)
require File.join(__DIR__, 'spec_helper')

describe Point do
  describe "#==" do
    context "when comparing two equal points" do
      it "should return true" do
        (Point[1, 1] == Point[1, 1]).should == true
      end
    end

    context "when comparing two different points" do
      it "should return false" do
        (Point[1, 3] == Point[1, 1]).should == false        
      end
    end

    context "when difference is withing floating point epsilon" do
      it "should return true" do
        (Point[1, 1 - Float::EPSILON] == Point[1, 1]).should == true
      end
    end
  end
  
  describe ".[]" do
    context "when passed with two numbers" do
      it "should create an instance" do
        Point[1, 3].should == Point.new(1, 3)
      end
    end
  end

  describe "#distance_to" do
    context "when points are equal" do
      it "should return zero" do
        Point[1, 1].distance_to(Point[1, 1]).should == 0
      end
    end

    context "when points are not equal" do
      it "should return Euqlid distance between them" do
        Point[1, 0].distance_to(Point[1, 1]).should == 1
        Point[-1, -1].distance_to(Point[1, 1]).should === 2 * Math.sqrt(2)
      end
    end
  end

  describe "#rotate_around" do
    it "should rotate correctly" do
      Point[1, 1].rotate_around(Point[0, 0], 90.degrees).should == Point[-1, 1]
      Point[1, 1].rotate_around(Point[0, 0], 270.degrees).should == Point[-1, -1]
      Point[2, 2].rotate_around(Point[1, 1], 180.degrees).should == Point[0, 0]
    end
  end
end
