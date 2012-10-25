require 'sequel'
require 'sequel/extensions/inflector'
require 'sinatra/base'
require 'omniauth'
require 'mustache/sinatra'

require 'erb'
require 'pathname'
require 'yaml'
require 'logger'

module Collect
  Root = (Pathname.new(File.dirname(__FILE__)) + '..').expand_path
  Env = ENV['RACK_ENV'] || 'development'

  config_path = Root + 'config' + 'database.yml'
  config_tmpl = ERB.new(File.read(config_path))
  config_tmpl.filename = config_path.to_s
  config = YAML.load(config_tmpl.result(binding))[Env]
  if config['logger']
    file = config['logger']
    config['logger'] = Logger.new(file == '_stderr_' ? STDERR : file)
  end
  Database = Sequel.connect(config)
end

path = Collect::Root + 'lib' + 'collect'
require path + 'exceptions'
require path + 'models'
require path + 'utils'
require path + 'application'
require path + 'extensions'
require path + 'views'
