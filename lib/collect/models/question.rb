module Collect
  class Question < Sequel::Model
    TYPES = %w{String Integer Float}
    many_to_one :section

    def validate
      super
      validates_presence [:name, :prompt, :type]
      validates_format /^[a-zA-Z0-9_]+$/, :name
      validates_includes TYPES, :type

      if errors.on(:name).nil? && section_id && section.form_id
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
      end
    end
  end
end
