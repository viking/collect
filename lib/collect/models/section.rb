module Collect
  class Section < Sequel::Model
    many_to_one :form
    one_to_many :questions

    attr_writer :questions_attributes

    def validate
      super
      validates_presence [:name, :form_id]

      if errors.on(:form_id).nil?
        # Check project for status
        if form.project.status == 'production'
          errors.add(:base, 'cannot be saved; project is in production')
        end
      end
    end

    def after_save
      questions_attributes =
        case @questions_attributes
        when Array
          @questions_attributes
        when Hash
          @questions_attributes.values
        else
          nil
        end

      if questions_attributes
        questions_attributes.each do |question_attributes|
          question = Question.new(question_attributes.merge(:section_id => pk))
          if !question.save
            raise Sequel::Rollback
          end
        end
      end

      super
    end
  end
end
