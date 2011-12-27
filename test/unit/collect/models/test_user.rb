require 'helper'

class TestUser < Test::Unit::TestCase
  def new_user(attribs = {})
    Collect::User.new({
      :username => 'foo'
    }.merge(attribs))
  end

  test "sequel model" do
    assert_equal Sequel::Model, Collect::User.superclass
  end

  test "requires username" do
    user = new_user(:username => nil)
    assert !user.valid?
  end

  test "requires unique username" do
    user_1 = new_user
    assert user_1.save

    user_2 = new_user
    assert !user_2.valid?
  end
end
