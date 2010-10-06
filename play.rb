#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require "rubygame"

require 'init'
require 'client/init'

maximum_resolution = Rubygame::Screen.get_resolution
puts "This display can manage at least " + maximum_resolution.join("x")

require 'drb'

server_uri = "druby://localhost:1100"
puts "Connecting to #{server_uri}"

game_objects = DRbObject.new nil, server_uri

GeekGame::Client.new(game_objects).run
