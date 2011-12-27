require 'helper'

class TestAuthentication < Test::Unit::TestCase
  def new_authentication(attribs = {})
    Collect::Authentication.new({
      :user => @user,
      :provider => 'foo',
      :uid => 'foobar'
    }.merge(attribs))
  end

  def setup
    super
    @user = Collect::User.create(:username => 'foo')
  end

  test "sequel model" do
    assert_equal Sequel::Model, Collect::Authentication.superclass
  end

  test "requires user_id" do
    auth = new_authentication(:user => nil)
    assert !auth.valid?
  end

  test "requires provider" do
    auth = new_authentication(:provider => nil)
    assert !auth.valid?
  end

  test "requires uid" do
    auth = new_authentication(:uid => nil)
    assert !auth.valid?
  end

  test "requires unique combination of user, provider, and uid" do
    auth_1 = new_authentication(:provider => 'foo', :uid => 'foobar')
    assert auth_1.save

    auth_2 = new_authentication(:provider => 'foo', :uid => 'foobar')
    assert !auth_2.valid?
  end
end
