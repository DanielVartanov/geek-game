#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "rubygame"
require "dirge"

require ~'init'
require ~'server/init'

timeline = GeekGame::Timeline.new

network_thread = Thread.new do
  network_server = GeekGame::NetworkServer.new timeline, 'localhost', 21000
  network_server.start!
end

timeline.start!
