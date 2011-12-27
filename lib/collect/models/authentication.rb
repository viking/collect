module Collect
  class Authentication < Sequel::Model
    many_to_one :user

    def validate
      super
      validates_presence [:user_id, :provider, :uid]
      validates_unique [:user_id, :provider, :uid]
    end
  end
end
