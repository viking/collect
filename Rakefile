require "bundler/gem_tasks"
require "rake/testtask"

task :environment, :env do |cmd, args|
  ENV["RACK_ENV"] = args[:env] || "development"
  require "./lib/collect"
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = 'test/**/test*.rb'
end
task :default => :test

namespace :db do
  desc "Run database migrations"
  task :migrate, :env do |cmd, args|
    env = args[:env] || "development"
    Rake::Task['environment'].invoke(env)

    require 'sequel/extensions/migration'
    Sequel::Migrator.apply(Collect::Database, "db/migrate")
  end

  desc "Rollback the database"
  task :rollback, :env do |cmd, args|
    env = args[:env] || "development"
    Rake::Task['environment'].invoke(env)

    require 'sequel/extensions/migration'
    version = (row = Collect::Database[:schema_info].first) ? row[:version] : nil
    Sequel::Migrator.apply(Collect::Database, "db/migrate", version - 1)
  end

  desc "Nuke the database (drop all tables)"
  task :nuke, :env do |cmd, args|
    env = args[:env] || "development"
    Rake::Task['environment'].invoke(env)

    constraints = {
      :forms => %w{forms_project_id_fkey},
      :sections => %w{sections_form_id_fkey},
      :questions => %w{questions_section_id_fkey},
      :authentications => %w{authentications_user_id_fkey},
      :roles => %w{roles_user_id_fkey roles_project_id_fkey}
    }
    Collect::Database.tables.each do |table|
      names = constraints[table]
      next if names.nil?

      Collect::Database.alter_table(table) do
        names.each do |name|
          drop_constraint(name)
        end
      end
    end
    Collect::Database.tables.each do |table|
      Collect::Database.run("DROP TABLE #{table}")
    end
    FileUtils.rm_f(Dir.glob("db/projects/#{env}/*").select { |f| f =~ /\/\d+$/ }, :verbose => true)
  end

  desc "Reset the database"
  task :reset, [:env] => [:nuke, :migrate]
end
