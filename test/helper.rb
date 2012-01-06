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

class CollectUnitTest < Test::Unit::TestCase
  def run(*args, &block)
    super
    [Collect::Question, Collect::Section, Collect::Form, Collect::Project, Collect::Authentication, Collect::User].each do |klass|
      klass.dataset.destroy
    end
  end
end

class CollectRackTest < CollectUnitTest
  include Rack::Test::Methods

  def setup_session(data = {})
    sid = SecureRandom.hex(32)
    hsh = data.merge("session_id" => sid)
    data = [Marshal.dump(hsh)].pack('m')
    secret = app.session_secret
    hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, secret, data)
    str = "#{data}--#{hmac}"
    set_cookie("rack.session=#{URI.encode_www_form_component(str)}")
  end
end

class CollectExtensionTest < CollectRackTest
  def app
    if !defined? @app
      @app = Class.new(Sinatra::Base)
      @app.enable :sessions
    end
    @app
  end

  def setup
    super
    klass = Collect::Extensions.const_get(self.class.name.sub(/^Test/, ""))
    app.register(klass)
  end
end
