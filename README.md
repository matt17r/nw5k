# README

## Getting started

Copy .env file...

```sh
cp .env.template .env
```

...and populate required settings (settings are in 1Password or on the server in `~/nw5k/.rbenv-vars`)

## Deploying

Ensure `CAPISTRANO_DEPLOYMENT_IP_ADDRESS` is set correctly (see above) and deploy with capistrano:

```sh
cap production deploy
```

## Copy prod data to dev

While I can still get away with it, the way to copy prod data to the dev environment is:

```sh
# TODO - create a capistrano task to make and download a database backup

pg_restore --verbose --clean --no-acl --no-owner -h localhost -d nw5k_development latest.dump

rm latest.dump
```

## To update Ruby

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
