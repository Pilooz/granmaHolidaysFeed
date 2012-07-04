namespace :db do
  RAMAZE_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  task :load_config do
    require(File.join(RAMAZE_ROOT, 'app'))
    Sequel.extension :migration
    Sequel.extension :schema_dumper
  end

  desc "Dumps the schema to db/schema.db"
  task :schemadump => :load_config do
    #foreign_key dump is sometimes wrong with non autoincrmente type (ie char)
    #so we need to dump the base in two times : the structure without foreign_keys and the foreigne_key alone
    schema = DB.dump_schema_migration(:foreign_key => false)
    schema_file = File.open(File.join(RAMAZE_ROOT, 'db', 'schema.rb'), "w"){|f| f.write(schema)}
    fk = DB.dump_foreign_key_migration
    fk_file = File.open(File.join(RAMAZE_ROOT, 'db', 'schema_fk.rb'), "w"){|f| f.write(fk)}
  end
  
  desc "Migrate the database through scripts in db/migrations and update db/schema.rb by invoking db:schemadump. Target specific version with VERSION=x. Turn off output with VERBOSE=false."
  task :migrate => :load_config do
    Sequel::Migrator.apply(DB, File.join(RAMAZE_ROOT, 'db', 'migrations'))
    Rake::Task["db:schemadump"].invoke
  end

  namespace :migrate do
    desc  'Rollbacks the database one migration and re migrate up. If you want to rollback more than one step, define STEP=x. Target specific version with VERSION=x.'
    task :redo => :load_config do
      Rake::Task["db:rollback"].invoke
      Rake::Task["db:migrate"].invoke
      Rake::Task["db:schemadump"].invoke
    end

    desc 'Runs the "up" for a given migration VERSION.'
    task :up => :load_config do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      raise "VERSION is required" unless version
      puts "migrating up to version #{version}"
      Sequel::Migrator.apply(DB, File.join(RAMAZE_ROOT, 'db', 'migrations'), version)
      Rake::Task["db:schemadump"].invoke
    end

    desc 'Runs the "down" for a given migration VERSION.'
    task :down => :load_config do
      step = ENV['STEP'] ? ENV['STEP'].to_i : 1
      current_version = Sequel::Migrator.get_current_migration_version(DB)
      down_version = current_version - step
      down_version = 0 if down_version < 0
      puts "migrating down to version #{down_version}"
      Sequel::Migrator.apply(DB, File.join(RAMAZE_ROOT, 'db', 'migrations'), down_version)
      Rake::Task["db:schemadump"].invoke
    end
  end

  desc 'Rolls the schema back to the previous version. Specify the number of steps with STEP=n'
  task :rollback => :load_config do
    Rake::Task["db:migrate:down"].invoke
  end
end
