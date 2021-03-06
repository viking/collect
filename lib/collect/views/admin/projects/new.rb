require File.join(File.dirname(__FILE__), "editor")

module Collect
  module Views
    module Admin
      module Projects
        class New < Editor
          def form_url
            "/admin/projects"
          end

          def submit_value
            "Create"
          end
        end
      end
    end
  end
end
