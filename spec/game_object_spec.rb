require 'spec_helper'

describe GameObject do
  context "when I create an instance" do
    before :each do
      @game_object = GameObject.new
    end

    it "should be added to a global game objects list" do
      GeekGame.game_objects.should include(@game_object)
    end
  end
end
