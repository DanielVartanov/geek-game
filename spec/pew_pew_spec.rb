require 'spec_helper'

describe PewPew do
  let(:bot) { PewPew.new }

  describe 'battery' do
    subject { bot.battery }

    context "when bot shoots" do
      before { bot.fire! }

      it "should be decreased by a constant value" do
        subject.charge.should == 1 - bot.shooting_cost
      end
    end
  end

  describe "firing" do
    context "when bot is just created" do
      it "should be able to fire immediately" do
        pending
      end
    end
  end

  describe "#to_hash" do
    subject { bot.to_hash }

    it "should contain gun" do
      subject[:gun].should == bot.gun.to_hash
    end
  end
end
