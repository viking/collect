module Collect
  class Section < Sequel::Model
    many_to_one :form
    one_to_many :questions

    plugin :nested_attributes
    nested_attributes :questions

    def validate
      super
      validates_presence [:name]
    end
  end
end
