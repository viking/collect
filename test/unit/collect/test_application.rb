require 'helper'

class TestApplication < CollectUnitTest
  include Rack::Test::Methods

  def app
    Collect::Application
  end

  def setup_session(data = {})
    sid = SecureRandom.hex(32)
    hsh = data.merge("session_id" => sid)
    data = [Marshal.dump(hsh)].pack('m')
    secret = app.session_secret
    hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, secret, data)
    str = "#{data}--#{hmac}"
    set_cookie("rack.session=#{URI.encode_www_form_component(str)}")
  end

  test "requires login" do
    get '/'
    assert_equal 302, last_response.status
    assert_equal 'http://example.org/auth/developer', last_response['location']
  end

  test "shows root after login" do
    user = Collect::User.create(:username => 'foo')
    setup_session(:user_id => user.id)
    get '/'
    assert_equal 200, last_response.status
  end

  test "authenticating existing user" do
    user = Collect::User.create(:username => 'foo')
    authentication = Collect::Authentication.create(:uid => 'foo', :provider => 'developer', :user => user)

    OmniAuth.config.mock_auth[:developer] = { :provider => 'developer', :uid => 'foo' }
    get '/auth/developer'
    follow_redirect!
    assert_equal 302, last_response.status
    assert_equal 'http://example.org/', last_response['location']
  end

  test "authenticating non-existant user" do
    OmniAuth.config.mock_auth[:developer] = { :provider => 'developer', :uid => 'foo' }
    get '/auth/developer'
    follow_redirect!
    assert_equal 302, last_response.status
    assert_equal 'http://example.org/auth/developer', last_response['location']
  end
end
