require 'spec_helper'

describe Player do
  describe "#factory" do
    context "when factory is assigned" do
      before do
        @factory = Factory.new :angle => 0, :position => Point(0, 0)
        @player = Player.new :color => [0, 0, 0]
        @player.factory = @factory
      end

      subject { @player.factory }

      it "should assign Factory#player" do
        subject.player.should == @player
      end

      it "should assign exactly given factory" do
        subject.should == @factory
      end
    end
  end
end
