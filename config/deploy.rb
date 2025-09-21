# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :application, "nw5k"
set :branch, "main"
set :deploy_to, "/home/matthew/#{fetch :application}"
set :keep_releases, 5
set :repo_url, "git@github.com:matt17r/nw5k.git"

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", ".bundle", "public/system", "public/uploads"
