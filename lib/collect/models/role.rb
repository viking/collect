module Collect
  class Role < Sequel::Model
    plugin :eager_each

    many_to_one :user
    many_to_one :project
    subset :admin, :is_admin => true

    def is_admin?
      is_admin
    end

    def validate
      super
      validates_presence [:user_id, :project_id]
    end
  end
end
