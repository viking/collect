require "bundler/gem_tasks"

task :environment, :env do |cmd, args|
  ENV["RACK_ENV"] = args[:env] || "development"
  require "./lib/collect"
end

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
    Collect::Database.tables.each do |table|
      Collect::Database.run("DROP TABLE #{table}")
    end
  end

  desc "Reset the database"
  task :reset, [:env] => [:nuke, :migrate]
end
