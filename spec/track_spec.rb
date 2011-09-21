require "spec_helper"

describe Track do
  let(:bot) { TrackedBot.new }
  let(:track) { bot.left_track }
  
  describe "#to_hash" do
    subject { track.to_hash }

    it { should == { :power => track.power } }
  end
end
