#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require "rubygame"

require 'init'
require 'server/init'

puts "=== Geek Game === Starting server at port 8989"

GeekGame::Server.new.run
