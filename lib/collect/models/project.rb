module Collect
  class Project < Sequel::Model
    plugin :serialization, :yaml, :database_options
    one_to_many :roles
    many_to_many :users, :join_table => :roles
    one_to_many :forms
    one_to_one :primary_form, :read_only => true, :class => "Collect::Form",
      :conditions => { :primary => true }

    def database(&block)
      opts = {:adapter => database_adapter}.merge(database_options || {})
      if database_adapter == 'sqlite'
        opts[:database] = sqlite_db_path
      end
      Sequel.connect(opts, &block)
    end

    private

    def sqlite_db_path
      @sqlite_db_path ||= (Root + 'db' + 'projects' + Env + pk.to_s).to_s
    end

    def validate
      super
      validates_presence :name
      validates_unique :name

      validates_presence :database_adapter
      if errors.on(:database_adapter).nil?
        begin
          Sequel::Database.adapter_class(database_adapter)
        rescue Sequel::AdapterNotFound
          errors.add(:database_adapter, "is not a valid adapter")
        end
      end
    end

    def after_destroy
      super
      if database_adapter == 'sqlite' && File.exist?(sqlite_db_path)
        File.unlink(sqlite_db_path)
      end
    end
  end
end
