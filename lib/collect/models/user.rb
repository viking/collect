module Collect
  class User < Sequel::Model
    def validate
      super
      validates_presence :username
      validates_unique :username
    end
  end
end
