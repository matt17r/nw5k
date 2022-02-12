# README

## Copy prod data to dev

While I can still get away with it, the way to copy prod data to the dev environment is:

```sh
heroku pg:backups:capture
heroku pg:backups:download

pg_restore --verbose --clean --no-acl --no-owner -h localhost -d nw5k_development latest.dump

rm latest.dump
``` 
