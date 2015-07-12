require 'spec_helper'

describe Factory do
  describe "#orientation" do
    context "when angle is given" do
      before do
        @factory = Factory.new :angle => 45.degrees
      end

      subject { @factory.orientation }

      it "should be unit" do
        subject.modulus.should == 1
      end

      it "should have given angle" do
        subject.angle.should == 45.degrees
      end
    end
  end
end
