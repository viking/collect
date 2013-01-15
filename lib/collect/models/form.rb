module Collect
  class Form < Sequel::Model
    many_to_one :project
    one_to_many :sections

    plugin :nested_attributes
    nested_attributes :sections

    plugin :dirty

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
      update(:status => 'published')
    end

    def published?
      initial_value(:status) == 'published'
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

      if initial_value(:status) == 'published'
        errors.add(:status, "is published; no changes allowed")
      end
    end
  end
end
