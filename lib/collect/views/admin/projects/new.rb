module Collect
  module Views
    module Admin
      module Projects
        class New < Layout
          attr_reader :project

          def has_errors?
            !project.errors.empty?
          end

          def errors
            project.errors.full_messages
          end
        end
      end
    end
  end
end
