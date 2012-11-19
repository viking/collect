require File.join(File.dirname(__FILE__), "editor")

module Collect
  module Views
    module Admin
      module Forms
        class Edit < Editor
          def action_url
            "/admin/projects/#{form.project_id}/forms/#{form.id}"
          end
        end
      end
    end
  end
end
