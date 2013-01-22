module Collect
  class Question < Sequel::Model
    TYPES = %w{String Integer Float}
    many_to_one :section

    def validate
      super
      validates_presence [:name, :prompt, :type, :section_id]
      validates_format /^[a-zA-Z0-9_]+$/, :name
      validates_includes TYPES, :type

      if errors.on(:name).nil? && errors.on(:section_id).nil?
        # Check name uniqueness across form
        ds = self.class.dataset.
          select(:questions__name).
          join(:sections, :id => :section_id).
          filter(:form_id => section.form_id, :questions__name => name)
        if !new?
          ds = ds.filter(~{:questions__id => id})
        end
        if ds.count > 0
          errors.add(:name, 'is already taken')
        end

        # Check project for status
        if section.form.project.status == 'production'
          errors.add(:base, 'cannot be saved; project is in production')
        end
      end
    end
  end
end
