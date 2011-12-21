require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'tempfile'

ENV['RACK_ENV'] = 'test'
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'collect'

class Test::Unit::TestCase
  def run_with_transaction(*args, &block)
    Sequel::Model.db.transaction(:rollback=>:always) { run_without_transaction(*args, &block) }
  end
  alias :run_without_transaction :run
  alias :run :run_with_transaction
end
