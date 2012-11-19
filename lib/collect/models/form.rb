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

      if project_id && primary
        ds = self.class.dataset.filter(:primary => true, :project_id => project_id)
        ds = ds.filter(~{:id => id}) if !new?

        if ds.count > 0
          errors.add(:primary, "cannot be true for more than one form")
        end
      end
    end
  end
end
