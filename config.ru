require 'rubygems'
require 'bundler'

Bundler.require

require './lib/collect'
run Collect::Application
