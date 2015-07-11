require_relative '../geek_game'
require_relative './support/world_helper'

include GeekGame

RSpec.configure do |c|
  c.include WorldHelper

  c.before(:each) do
    GeekGame.reset!
  end
end
