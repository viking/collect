module Collect
  class User < Sequel::Model
    one_to_many :roles
    many_to_many :projects, :join_table => :roles

    def validate
      super
      validates_presence :username
      validates_unique :username
    end
  end
end
