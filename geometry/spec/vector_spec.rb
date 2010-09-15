__DIR__ = File.dirname(__FILE__)
require File.join(__DIR__, 'spec_helper')

describe Vector do
  describe "Vector[]" do
    context "when passed with two numbers" do
      before :each do
        @vector = Vector(1, 3)
      end

      it "should create a vector with given coordinates" do
        @vector.should be_a(Vector)
        @vector.x.should == 1
        @vector.y.should == 3
      end
    end
  end

  describe "#signed_angle_with" do
    context "when angle is less than Pi" do
      before :each do
        @vector = Vector(1, 0)
        @another_vector = Vector(0, 1)
      end

      it "should return angle" do
        @vector.signed_angle_with(@another_vector).should === 90.degrees
      end
    end

    context "when CCW-angle is greater than Pi" do
      before :each do
        @vector = Vector(1, 1)
        @another_vector = Vector(1, -1)
      end

      it "should return negative angle" do
        @vector.signed_angle_with(@another_vector).should === -90.degrees
      end
    end
  end

  describe "#angle_with" do
    context "when angle is less than Pi" do
      before :each do
        @vector = Vector(1, 0)
        @another_vector = Vector(0, 1)
      end

      it "should return angle" do
        @vector.angle_with(@another_vector).should === 90.degrees
      end
    end

    context "when CCW-angle is greater than Pi" do
      before :each do
        @vector = Vector(1, 1)
        @another_vector = Vector(1, -1)
      end

      it "should still return smallest positive angle" do
        @vector.angle_with(@another_vector).should === 90.degrees
      end
    end
  end
end
