module Collect
  module Views
    module Admin
      module Forms
        class Editor < Layout
          attr_reader :role, :project, :form

          def has_errors?
            !form.errors.empty?
          end

          def errors
            form.errors.full_messages
          end

          def sections
            @sections ||= form.sections.collect.with_index do |section, i|
              questions = section.questions.collect.with_index do |question, j|
                { 'question' => question, 'question_index' => j }
              end
              { 'section' => section, 'section_index' => i, 'questions' => questions }
            end
          end

          def question_types
            Question::TYPES
          end

          def question_types_json
            question_types.to_json
          end

          def section_template
            @section_template ||= @template_cache.fetch(:raw, :mustache, 'admin/forms/section') do
              File.read((Collect::Root + 'templates' + 'admin' + 'forms' + 'section.mustache').to_s)
            end
          end

          def question_template
            @question_template ||= @template_cache.fetch(:raw, :mustache, 'admin/forms/question') do
              File.read((Collect::Root + 'templates' + 'admin' + 'forms' + 'question.mustache').to_s)
            end
          end
        end
      end
    end
  end
end
