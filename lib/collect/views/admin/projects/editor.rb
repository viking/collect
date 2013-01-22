module Collect
  module Views
    module Admin
      module Projects
        class Editor < Layout
          attr_reader :project

          def has_errors?
            !project.errors.empty?
          end

          def errors
            project.errors.full_messages
          end

          def status_values
            %w{development production}.collect do |value|
              { :value => value, :selected =>
                @project.status == value ? " selected='selected'" : "" }
            end
          end
        end
      end
    end
  end
end
