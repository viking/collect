require 'helper'

class TestApplication < CollectRackTest
  def app
    Collect::Application
  end

  test "subclass of Sinatra::Base" do
    assert_equal Sinatra::Base, app.superclass
  end
end
