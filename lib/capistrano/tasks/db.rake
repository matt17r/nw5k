namespace :db do
  desc "Dump the database and download to local machine"
  task :dump do
    on roles(:db) do
      within "#{current_path}" do
        with rails_env: "#{fetch(:stage)}" do
          puts "Creating DB dump file (output hidden)..."
          SSHKit.config.use_format :dot # Hide password from console (and log?)
          execute redact("PGPASSWORD='#{ENV["NW5K_DATABASE_PASSWORD"]}'"), "pg_dump --verbose  -Fc --no-acl --no-owner  -h localhost -d nw5k_production -U nw5k > tmp/latest.dump"
          SSHKit.config.use_format :pretty
          puts "Downloading DB dump file..."
          download! "tmp/latest.dump", "tmp/latest.dump"
          puts "Removing dump file from server..."
          execute :rm, "tmp/latest.dump"
        end
      end
    end
  end

  desc "Restore the downloaded database to dev on local machine"
  task :restore do
    run_locally do
      with rails_env: :development do
        puts "Restoring database"
        execute "pg_restore --verbose --clean --no-acl --no-owner -h localhost -d nw5k_development tmp/latest.dump"
        puts "Remove dump file from local"
        execute :rm, "tmp/latest.dump"
      end
    end
  end
end
