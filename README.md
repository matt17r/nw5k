# README

## Copy prod data to dev

While I can still get away with it, the way to copy prod data to the dev environment is:

```sh
heroku pg:backups:capture
heroku pg:backups:download

pg_restore --verbose --clean --no-acl --no-owner -h localhost -d nw5k_development latest.dump

rm latest.dump
```

## To update Ruby

If you see warnings from Heroku about a more recent Ruby version being available:

- Install latest stable version of Ruby
  ```sh
  brew upgrade rbenv ruby-build
  rbenv install -l # List latest stable versions
  rbenv install <stable version>
  rbenv local <stable version> # Updates value in /.ruby-version
  ```  
- Update Ruby version in Gemfile
- Install gems into new version of Ruby  
  `bundle install`
