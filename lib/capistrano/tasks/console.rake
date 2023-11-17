namespace :rails do
  desc "Open the rails console on one of the remote servers"
  task :console do |current_task|
    on roles(:app) do |server|
      server ||= find_servers_for_task(current_task).first
      exec %Q[ssh -l #{server.user||fetch(:user)} #{server.hostname} -p #{server.port || 22} -t 'export PATH="$HOME/.rbenv/bin:$PATH"; eval "$(rbenv init -)"; cd #{release_path}; bin/rails console -e production']
    end
  end
end
