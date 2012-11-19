require File.join(File.dirname(__FILE__), "editor")

module Collect
  module Views
    module Admin
      module Forms
        class New < Editor
          def action_url
            "/admin/projects/#{@project.id}/forms"
          end
        end
      end
    end
  end
end
