module Collect
  class Role < Sequel::Model
    many_to_one :user
    many_to_one :project

    def is_admin?
      is_admin
    end

    def validate
      super
      validates_presence [:user_id, :project_id]
    end
  end
end
