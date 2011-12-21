module Collect
  class Form < Sequel::Model
    many_to_one :project
    one_to_many :sections

    def publish!
      if status == 'published'
        raise FormAlreadyPublishedException
      end

      project.database do |db|
        ds = sections_dataset.naked.
          select(:questions.*).
          join(:questions, :section_id => :id)

        db.create_table(slug.pluralize) do
          primary_key :id
          ds.each do |question|
            send(question[:type], question[:name])
          end
        end
      end
      self.status = 'published'
      save
    end

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
