module Collect
  class Form < Sequel::Model
    many_to_one :project
    one_to_many :sections

    attr_writer :sections_attributes

    def before_validation
      super
      if name && (slug.nil? || slug.empty?)
        self.slug = Utils.slugify(name)
      end
    end

    def validate
      super
      validates_presence [:name, :project_id]
      validates_unique :name, :slug

      if errors.on(:project_id).nil? && project.status == "production"
        errors.add(:base, "cannot be saved; project is in production")
      end
    end

    def after_save
      sections_attributes =
        case @sections_attributes
        when Array
          @sections_attributes
        when Hash
          @sections_attributes.values
        else
          nil
        end

      if sections_attributes
        sections_attributes.each do |section_attributes|
          section = Section.new(section_attributes.merge(:form_id => pk))
          if !section.save
            raise Sequel::Rollback
          end
        end
      end

      super
    end
  end
end
