require 'spec_helper'

describe GameObject do
  context "when I create an instance" do
    before :each do
      @game_object = GameObject.new
    end

    it "should be added to a global game objects list" do
      GeekGame.game_objects.should include(@game_object)
    end

    describe "#die!" do
      context "when called!" do
        before { @game_object.die! }

        it "should no longer present in global GameObjects list" do
          GeekGame.game_objects.should_not include(@game_object)
        end
      end
    end
  end
end
