source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

gem "bcrypt"
gem "bootsnap", require: false
gem "cssbundling-rails"
gem "csv"
gem "jsbundling-rails"
gem "pg"
gem "puma"
gem "rails"
gem "redis"
gem "scenic"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development do
  gem "capistrano", "~> 3.17"
  gem "capistrano-passenger", "~> 0.2.1"
  gem "capistrano-rails", "~> 1.6"
  gem "capistrano-rbenv", "~> 2.2"
  gem "foreman"
  gem "rack-mini-profiler"
  gem "stackprof"
  gem "web-console"
end

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "standard"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

gem "honeybadger", "~> 5.3"
