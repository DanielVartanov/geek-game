#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "rubygame"
require "dirge"

require ~'geek_game'
require ~'server/server'

timeline = GeekGame::Timeline.new
timeline.start!
