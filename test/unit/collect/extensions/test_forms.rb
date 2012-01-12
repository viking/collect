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
    form = stub('form')
    Collect::Form.expects(:new).returns(form)
    get '/admin/projects/1/forms/new'
    assert_equal 200, last_response.status
  end
end
