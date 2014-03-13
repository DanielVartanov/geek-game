$:.unshift File.dirname(__FILE__) + '/../../'
require "geek_game.rb"
require "client/client.rb"

require "dirge"
require "bson"

require_relative "stubs/socket_stub"

include GeekGame
