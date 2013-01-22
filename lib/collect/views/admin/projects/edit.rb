require File.join(File.dirname(__FILE__), "editor")

module Collect
  module Views
    module Admin
      module Projects
        class Edit < Editor
          def form_url
            "/admin/projects/#{@project.id}"
          end

          def submit_value
            "Update"
          end
        end
      end
    end
  end
end
