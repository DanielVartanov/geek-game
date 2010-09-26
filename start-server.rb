#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require "rubygame"

require 'init'
require 'server/init'

require 'drb'

game_server = GeekGame::Server.new

DRb.start_service "druby://desktop:1100", GeekGame.game_objects

puts "=== Geek Game === Starting server at #{DRb.uri}"

game_server.run
