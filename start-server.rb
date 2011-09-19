#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "rubygame"
require "dirge"

require ~'geek_game'
require ~'server/init'

Thread.abort_on_exception = true

timeline = GeekGame::Timeline.new

network_thread = Thread.new do
  network_server = GeekGame::Network::Server.new timeline, 'localhost', 21000
  network_server.start!
end

timeline.start!
