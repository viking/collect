module Collect
  class Form < Sequel::Model
    many_to_one :project
    one_to_many :sections

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
    end
  end
end
