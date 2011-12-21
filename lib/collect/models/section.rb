module Collect
  class Section < Sequel::Model
    many_to_one :form
    one_to_many :questions

    def validate
      super
      validates_presence [:name, :form_id]
    end
  end
end
