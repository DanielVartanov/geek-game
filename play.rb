#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require "rubygame"

require 'init'

maximum_resolution = Rubygame::Screen.get_resolution
puts "This display can manage at least " + maximum_resolution.join("x")

GeekGame.new.run
