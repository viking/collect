require 'helper'

class TestUser < CollectUnitTest
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

  test "one_to_many roles" do
    assert_respond_to Collect::User.new, :roles
  end

  test "many_to_many projects (through roles)" do
    user = new_user
    assert user.save

    project = Collect::Project.create!(:name => 'foo', :database_adapter => 'sqlite')
    role = Collect::Role.create!(:user => user, :project => project)

    assert_equal [project], user.projects
  end

  test "roles_with_active_projects" do
    user = new_user
    assert user.save

    project_1 = Collect::Project.create!({
      :name => 'foo', :database_adapter => 'sqlite',
      :status => 'development'
    })
    project_2 = Collect::Project.create!({
      :name => 'bar', :database_adapter => 'sqlite',
      :status => 'production'
    })
    project_3 = Collect::Project.create!({
      :name => 'baz', :database_adapter => 'sqlite',
      :status => 'development'
    })

    role_1 = Collect::Role.create!(:user => user, :project => project_1, :is_admin => true)
    role_2 = Collect::Role.create!(:user => user, :project => project_2)
    role_3 = Collect::Role.create!(:user => user, :project => project_3)

    assert_equal [role_1, role_2], user.roles_with_active_projects
  end
end
