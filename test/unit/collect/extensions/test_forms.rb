require 'helper'

class TestForms < CollectExtensionTest
  def setup
    super
    @project = project = stub('project', :id => 1, :name => 'foo')
    @role = role = stub('role', :project => project, :is_admin => true)
    app.before do
      @project = project
      @role = role
    end
  end

  test "new form" do
    section = stub('section', :name => 'main', :position => 0, :questions => [])
    form = stub('form', :name => nil, :errors => [], :sections => [section])
    Collect::Form.expects(:new).with(:project => @project).returns(form)
    form.expects(:sections_attributes=).with([{:name => 'main', :position => 0}])

    get '/admin/projects/1/forms/new'
    assert_equal 200, last_response.status
  end
end
