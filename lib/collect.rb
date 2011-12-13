require 'sequel'
require 'erb'
require 'pathname'

module Collect
  Root = (Pathname.new(File.dirname(__FILE__)) + '..').expand_path

  config_path = Root + 'config' + 'database.yml'
  config_tmpl = ERB.new(File.read(config_path))
  config_tmpl.filename = config_path.to_s
  config = YAML.load(config_tmpl.result(binding))
  Database = Sequel.connect(config[ENV['RACK_ENV'] || 'development'])
end
