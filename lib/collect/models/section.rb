module Collect
  class Section < Sequel::Model
    many_to_one :form

    def validate
      super
      validates_presence [:name, :form_id]
    end
  end
end
