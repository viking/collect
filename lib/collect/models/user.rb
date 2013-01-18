module Collect
  class User < Sequel::Model
    one_to_many :roles
    many_to_many :projects, :join_table => :roles
    one_to_many :roles_with_active_projects, :class => 'Collect::Role',
      :read_only => true, :eager_graph => :project,
      :conditions => ({:roles__is_admin => true} | {:project__status => 'production'})

    def validate
      super
      validates_presence :username
      validates_unique :username
    end
  end
end
