module Collect
  class Project < Sequel::Model
    plugin :serialization, :yaml, :database_options

    def database(&block)
      opts = {:adapter => database_adapter}.merge(database_options || {})
      if database_adapter == 'sqlite'
        opts[:database] = sqlite_db_path
      end
      Sequel.connect(opts, &block)
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
      if database_adapter == 'sqlite'
        File.unlink(sqlite_db_path)
      end
    end

    private

    def sqlite_db_path
      (Root + 'db' + 'projects' + Env + pk.to_s).to_s
    end
  end
end
