require 'helper'

class TestProjects < CollectExtensionTest
  test "projects index with no projects" do
    @current_user.expects(:roles).returns([])
    get '/projects'
  end

  test "projects index with projects" do
    project_1 = stub('project 1', :id => 1, :name => 'foo')
    role_1 = stub('role 1', :project => project_1, :is_admin => true)
    project_2 = stub('project 2', :id => 2, :name => 'bar')
    role_2 = stub('role 2', :project => project_2, :is_admin => false)
    @current_user.expects(:roles).returns([role_1, role_2])
    get '/projects'
  end

  test "new project form" do
    project = stub('new project', :name => nil, :errors => stub(:empty? => true))
    Collect::Project.expects(:new).returns(project)
    get '/admin/projects/new'
  end

  test "creating a project successfully" do
    project = stub('new project', :name => nil)
    Collect::Project.expects(:new).with('name' => 'foo').returns(project)
    project.expects(:save).returns(true)
    project.stubs(:id).returns(1)
    Collect::Role.expects(:create).with(:user_id => 1, :project_id => 1, :is_admin => true)

    post '/admin/projects', {'project' => {'name' => 'foo'}}
    assert_equal 302, last_response.status
    assert_equal 'http://example.org/admin/projects/1', last_response['location']
  end

  test "creating an invalid project" do
    project = stub('new project', :name => 'foo')
    Collect::Project.expects(:new).with('name' => 'foo').returns(project)
    project.expects(:save).returns(false)
    project.expects(:errors).returns(stub(:empty? => false, :full_messages => ['foo']))

    post '/admin/projects', {'project' => {'name' => 'foo'}}
    assert_equal 200, last_response.status
  end

  test "admin project page with no forms" do
    project = stub('project', :name => 'foo', :forms => [])
    role = stub('role', :project => project, :is_admin => true)
    Collect::Role.expects(:[]).with(:project_id => '1', :user_id => 1, :is_admin => true).returns(role)

    get '/admin/projects/1'
    assert_equal 200, last_response.status
  end

  test "admin project page for unauthorized user" do
    Collect::Role.expects(:[]).with(:project_id => '1', :user_id => 1, :is_admin => true).returns(nil)

    get '/admin/projects/1'
    assert_equal 403, last_response.status
  end

  test "project page with no forms" do
    project = stub('project', :name => 'foo', :forms => [])
    role = stub('role', :project => project, :is_admin => false)
    Collect::Role.expects(:[]).with(:project_id => '1', :user_id => 1).returns(role)

    get '/projects/1'
    assert_equal 200, last_response.status
  end

  test "project page for unauthorized user" do
    Collect::Role.expects(:[]).with(:project_id => '1', :user_id => 1).returns(nil)

    get '/projects/1'
    assert_equal 403, last_response.status
  end
end
