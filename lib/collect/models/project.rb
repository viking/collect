module Collect
  class Project < Sequel::Model
    one_to_many :roles
    many_to_many :users, :join_table => :roles
    one_to_many :forms
    subset :production, :status => 'production'

    plugin :serialization, :yaml, :database_options
    plugin :dirty

    def database(&block)
      opts = {
        :adapter => database_adapter,
        :logger => Logger.new(STDERR)
      }.merge(database_options || {})
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

      if !new? && initial_value(:status) == 'production'
        errors.add(:base, 'cannot be saved; project is in production')
      end
    end

    def after_save
      if initial_value(:status) != 'production' && status == 'production'
        create_tables
      end
      super
    end

    def after_destroy
      super
      if database_adapter == 'sqlite' && File.exist?(sqlite_db_path)
        File.unlink(sqlite_db_path)
      end
    end

    def create_tables
      database do |db|
        db.create_table(:records) do
          primary_key :id
          String :status
        end

        forms.each do |form|
          ds = form.sections_dataset.naked.
            select(:questions.*).
            join(:questions, :section_id => :id)

          db.create_table(form.slug.pluralize) do
            primary_key :id
            ds.each do |question|
              send(question[:type], question[:name])
            end
            foreign_key :record_id, :records
          end
        end
      end
    end
  end
end
