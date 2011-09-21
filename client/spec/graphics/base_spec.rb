require "spec_helper"

describe Graphics::Base do
  describe ".create_from" do
    let(:game_object) do
      {
        :type => "tracked_bot",
        :position => [-28.894112991630443, -77.27638497287744],
        :angle => -6.424728038547264
      }
    end

    subject { Graphics::Base.create_from game_object, {} }

    it { should be_instance_of(Graphics::TrackedBot) }

    its(:position) { should == Point(-28.894112991630443, -77.27638497287744) }

    its(:angle) { should == game_object[:angle] }
  end
end
