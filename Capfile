require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
require "capistrano/rails"
require "capistrano/rbenv"
require "capistrano/passenger"
require "dotenv/load"

set :rbenv_type, :user
set :rbenv_ruby, "3.1.3"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
