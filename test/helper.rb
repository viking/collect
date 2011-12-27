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
require 'rack/test'
require 'tempfile'
require 'securerandom'

ENV['RACK_ENV'] = 'test'
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'collect'

OmniAuth.config.test_mode = true

class Test::Unit::TestCase
  def run_with_transaction(*args, &block)
    run_without_transaction(*args, &block)
    [Collect::Question, Collect::Section, Collect::Form, Collect::Project, Collect::Authentication, Collect::User].each do |klass|
      klass.dataset.destroy
    end
  end
  alias :run_without_transaction :run
  alias :run :run_with_transaction
end
