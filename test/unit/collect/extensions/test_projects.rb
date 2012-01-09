require 'helper'

class TestProjects < CollectExtensionTest
  test "projects index with no projects" do
    @current_user.expects(:projects).returns([])
    get '/projects'
  end
end
