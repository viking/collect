require 'helper'

class TestProject < CollectUnitTest
  def new_project(attribs = {})
    Collect::Project.new({
      :name => 'Foo',
      :database_adapter => 'sqlite'
    }.merge(attribs))
  end

  test "Sequel model" do
    assert_equal Sequel::Model, Collect::Project.superclass
  end

  test "requires name" do
    project = new_project(:name => nil)
    assert !project.valid?
  end

  test "requires unique name" do
    project_1 = new_project(:name => 'Foo')
    assert project_1.save
    project_2 = new_project(:name => 'Foo')
    assert !project_2.valid?
  end

  test "requires database_adapter" do
    project = new_project(:database_adapter => nil)
    assert !project.valid?
  end

  test "requires valid database_adapter" do
    project = new_project(:database_adapter => 'blah')
    assert !project.valid?
  end

  test "serializes database_options" do
    project = new_project(:database_options => {:foo => 'bar'})
    assert project.save
    project.reload
    assert_equal({:foo => 'bar'}, project.database_options)
  end

  test "sqlite database uses db directory" do
    project = new_project
    assert project.save
    project.database do |db|
      assert_equal 'sqlite', db.opts[:adapter]
      assert_equal "#{Collect::Root}/db/projects/test/#{project.id}", db.opts[:database]
    end
  end

  test "deletes sqlite3 database on destroy" do
    project = new_project
    assert project.save
    project.database do |db|
      db.test_connection
    end
    path = (Collect::Root + 'db' + 'projects' + 'test' + project.id.to_s).to_s
    assert File.exist?(path)
    project.destroy
    assert !File.exist?(path)
  end

  test "one_to_many forms" do
    project = new_project
    assert_respond_to project, :forms
  end

  test "one_to_many roles" do
    assert_respond_to Collect::Project.new, :roles
  end

  test "many_to_many users (through roles)" do
    user = Collect::User.create!(:username => 'foo')
    project = new_project
    assert project.save
    role = Collect::Role.create!(:user => user, :project => project)

    assert_equal [user], project.users
  end

  test "initial status" do
    project = new_project
    project.save
    assert_equal 'development', project.status
  end

  test "production subset" do
    project = new_project(:status => 'production')
    project.save
    assert_equal 1, Collect::Project.production.count
    assert_equal project, Collect::Project.production.first
  end

  test "moving to production creates tables" do
    project = new_project.save
    form = Collect::Form.create!(:name => 'foo', :project => project,
      :sections_attributes => [{
        :name => 'main',
        :questions_attributes => [
          {:name => 'first_name', :prompt => 'First name:', :type => 'String'},
          {:name => 'last_name', :prompt => 'Last name:', :type => 'String'}
        ]
      }])
    project.update(:status => 'production')
    project.database do |db|
      assert_include db.tables, :records
      assert_include db.tables, :foos
      assert_equal [:id, :first_name, :last_name, :record_id],
        db.schema(:foos).collect(&:first)
    end
  end

  test "can't save after in production" do
    project = new_project(:status => 'production').save
    assert !project.update(:status => 'development')
    assert !project.update(:name => 'blah')
  end
end
