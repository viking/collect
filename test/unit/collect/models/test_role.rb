require 'helper'

class TestRole < CollectUnitTest
  def new_role(attribs = {})
    Collect::Role.new({
      :user_id => 1,
      :project_id => 1
    }.merge(attribs))
  end

  test "sequel model" do
    assert_equal Sequel::Model, Collect::Role.superclass
  end

  test "requires user_id" do
    role = new_role(:user_id => nil)
    assert !role.valid?
  end

  test "requires project_id" do
    role = new_role(:project_id => nil)
    assert !role.valid?
  end

  test "many_to_one user" do
    assert_respond_to Collect::Role.new, :user
  end

  test "many_to_one project" do
    assert_respond_to Collect::Role.new, :project
  end

  test "is_admin?" do
    role = new_role(:is_admin => true)
    assert role.is_admin?
  end

  test "admin subset" do
    user_1 = Collect::User.create!(:username => 'foo')
    user_2 = Collect::User.create!(:username => 'bar')
    project = Collect::Project.create!(:name => 'baz', :database_adapter => 'sqlite')
    role_1 = Collect::Role.create!(:user => user_1, :project => project)
    role_2 = Collect::Role.create!(:user => user_1, :project => project, :is_admin => true)

    assert_equal [role_2], Collect::Role.admin.all
  end
end
