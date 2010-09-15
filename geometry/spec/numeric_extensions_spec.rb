__DIR__ = File.dirname(__FILE__)
require File.join(__DIR__, 'spec_helper')

describe Numeric do
  describe "#degrees" do
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

  describe "#sign" do
    context "when number is positive" do
      it "should return 1" do
        -25.3.sign.should == -1
      end
    end

    context "when number is zero" do
      it "should return 0" do
        0.sign.should == 0
      end
    end

    context "when number is close to zero" do
      it "should return 0" do
        Float::EPSILON.sign.should == 0
      end
    end

    context "when number is negative" do
      it "should return -1" do
        (-Math.sqrt(2)).sign.should == -1
      end
    end
  end

  describe "#zero?" do
    context "when number is zero" do
      it "should return true" do
        0.zero?.should == true
      end
    end

    context "when number is close to zero" do
      it "should return true too" do
        (- Float::EPSILON).zero?.should == true
        Float::EPSILON.zero?.should == true
      end
    end

    context "when number is far from zero" do
      it "should return false" do
        1.zero?.should == false
        (-Math.sqrt(2)).zero?.should == false
      end
    end
  end

  describe "#===" do
    context "when two floats are close" do
      subject { (3 - Float::EPSILON) === 3 }

      it { should be_true }
    end

    context "when fixnum is close to float" do
      subject { 3 === (3 + Float::EPSILON) }
      
      it { should be_true }
    end

    context "when two fixnums are equal" do
      subject { 3 === 3 }

      it { should be_true }
    end

    context "when two fixnums are not equal" do
      subject { 2 === 3 }

      it { should be_false }
    end
  end
end
