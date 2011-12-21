module Collect
  class Form < Sequel::Model
    many_to_one :project

    def before_validation
      super
      if name && (slug.nil? || slug.empty?)
        self.slug = Utils.slugify(name)
      end
    end

    def validate
      super
      validates_presence :name
      validates_unique :name, :slug
    end
  end
end
