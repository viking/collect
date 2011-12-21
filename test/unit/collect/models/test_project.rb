require 'helper'

class TestProject < Test::Unit::TestCase
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
      # NOTE: there should be an additional slash in the URI, but
      # Sequel doesn't put it there when using Sequel.connect with
      # an option hash

      assert_equal "sqlite:/#{Collect::Root}/db/projects/test/#{project.id}", db.uri
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
end
