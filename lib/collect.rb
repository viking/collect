require 'sequel'
require 'sequel/extensions/inflector'
require 'erb'
require 'pathname'
require 'yaml'

module Collect
  Root = (Pathname.new(File.dirname(__FILE__)) + '..').expand_path
  Env = ENV['RACK_ENV'] || 'development'

  config_path = Root + 'config' + 'database.yml'
  config_tmpl = ERB.new(File.read(config_path))
  config_tmpl.filename = config_path.to_s
  config = YAML.load(config_tmpl.result(binding))
  Database = Sequel.connect(config[Env])
end

path = Collect::Root + 'lib' + 'collect'
require path + 'exceptions'
require path + 'models'
require path + 'utils'
