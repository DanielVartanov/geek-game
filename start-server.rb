#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "rubygame"

require_relative 'geek_game'
require_relative 'server/server'

timeline = GeekGame::Timeline.new
timeline.start!
