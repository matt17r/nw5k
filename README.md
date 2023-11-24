# README

This is the code for the nw5k.com website. NW5k is a free, weekly, timed, 5k run/walk in the spirit of parkrun. NW5k was started because we wanted a local parkrun in Phnom Penh but [parkrun aren't currently expanding to new countries](https://www.parkrun.com/about/start-your-own-event/)... and even if they were, I worry that they wouldn't be okay with the compromises required to make this event happen in a developing nation with very little in the way of parks or public infrastructure.

## Architecture

This is a Ruby on Rails app running on a VPS (currently Azure, thanks to free credits) and using PostgreSQL as the database. It is deployed using Capistrano.

The app itself uses Tailwind CSS for styling, Hotwire (Turbo and Stimulus) for [very limited] interactivity, and I18n to translate the application into Khmer and Mandarin (Chinese).

Currently there is no test suite. I'm not proud of that but it is what it is. If/when I do add tests they will use Minitest.

## Development

I'm a team of one so these instructions are mainly to help future me if I ever need to set up a new development environment.

### Getting Started

Copy .env file...

```sh
cp .env.template .env
```

...and populate required settings (settings are in 1Password or on the server in `~/nw5k/.rbenv-vars`)

### Deploying

Ensure `CAPISTRANO_DEPLOYMENT_IP_ADDRESS` is set correctly (see above) and deploy with capistrano:

```sh
cap production deploy
```

New environment variables should be added to:

 - `.env` for development (do not commit this file into git or any other version control)
 - `.env.template` sanitised and committed (as a pointer for future me to know what variables are required)
 - `/home/matthew/nw5k/.rbenv-vars` on the server to be picked up in production by [rbenv-vars](https://github.com/rbenv/rbenv-vars)

### Copy prod data to dev

While I can still get away with it, the way to copy prod data to the dev environment is:

```sh
cap production db:dump

cap production db:restore
```

### To update Ruby

- Install latest stable version of Ruby
  ```sh
  brew upgrade rbenv ruby-build
  rbenv install -l # List latest stable versions
  rbenv install <stable version>
  rbenv local <stable version> # Updates value in /.ruby-version
  ```
- Update Ruby version in Gemfile
- Update bundler
  `bundle update --bundler`
- Install gems into new version of Ruby
  `bundle install`
- Commit
- Update Ruby version in Capfile
- Deploy
