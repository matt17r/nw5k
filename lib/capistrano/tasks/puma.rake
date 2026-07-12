namespace :puma do
  desc "Restart Puma"
  task :restart do
    on roles(:app) do
      execute "systemctl --user restart puma-nw5k"
    end
  end
end

after "deploy:published", "puma:restart"
