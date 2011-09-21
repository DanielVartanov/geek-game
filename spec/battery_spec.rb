require "spec_helper"

describe Battery do
  let(:battery) { Battery.new }
  
  describe "#to_hash" do
    subject { battery.to_hash }

    it { should == { :charge => battery.charge } }
  end
end
