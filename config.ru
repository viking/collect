require 'rubygems'
require 'bundler'

Bundler.require

require './lib/collect'
require 'sinatra/reloader'

Collect::Application.class_eval do
  register(Sinatra::Reloader)
  also_reload('lib/collect/**/*.rb')
end

run Collect::Application
