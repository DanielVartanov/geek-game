#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "rubygame"
require "dirge"

require ~'geek_game'
require ~'geometry/init'
require ~'client/client'

maximum_resolution = Rubygame::Screen.get_resolution
puts "This display can manage at least " + maximum_resolution.join("x")

GeekGame::Client.new('localhost', 21000).start!
