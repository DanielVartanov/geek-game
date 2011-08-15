#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "rubygame"
require "dirge"
require 'drb'

require ~'init'
require ~'server/init'

game_server = GeekGame::Server.new

DRb.start_service "druby://localhost:1100", GeekGame.game_objects

puts "=== Geek Game === Starting server at #{DRb.uri}"

game_server.run
