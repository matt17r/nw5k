# Stack modernisation — nw5k

This branch brings nw5k into line with the other apps (ws10, daily-bread):
Ruby 4, Rails 8.1 defaults, Propshaft, importmap, Tailwind v4, and
SQLite + Solid Cache/Queue/Cable.

> **This branch was prepared in an environment where Ruby 4.0.2 could not be
> installed, so `bundle install`, app boot, and the test suite were NOT run.**
> Everything below needs to be verified locally on Ruby 4.0.2. `Gemfile.lock`
> was intentionally left untouched — regenerate it with `bundle install`.

## What changed

### Ruby & framework
- `.ruby-version` → `4.0.2`
- `config.load_defaults 7.0` → `8.1` (see risk note below)
- `config.cache_classes` → `config.enable_reloading` (the former was removed in Rails 8) in all three environments

### JavaScript: esbuild/yarn → importmap
- Added `importmap-rails`, `config/importmap.rb`, `bin/importmap`
- `app/javascript/application.js` and `controllers/index.js` now use importmap + eager-loaded Stimulus controllers
- Layout uses `javascript_importmap_tags`
- **tom-select** (the one npm dependency) was bundled to a single ESM file and vendored at `vendor/javascript/tom-select.js` (pinned in `config/importmap.rb`)
- Removed `package.json`, `yarn.lock`, `jsbundling-rails`

### CSS: cssbundling + Tailwind v3 → tailwindcss-rails v4
- `app/assets/tailwind/application.css` is the new CSS-first entry: `@import "tailwindcss"`, custom colours ported to `@theme`, `@plugin "@tailwindcss/forms"`
- tom-select's base CSS vendored at `app/assets/tailwind/tom-select.css` and `@import`ed
- Removed `tailwind.config.js`, `app/assets/stylesheets/application.tailwind.css`, `cssbundling-rails`
- `Procfile.dev` now runs `bin/rails tailwindcss:watch`

### Asset pipeline: Sprockets → Propshaft
- Added `propshaft`, removed `sprockets-rails` and `app/assets/config/manifest.js`
- Trimmed Sprockets-only options from `config/environments/production.rb` and `config/initializers/assets.rb`

### Database: PostgreSQL + Redis → SQLite + Solid
- `config/database.yml` → multi-database SQLite (primary/cache/queue/cable), stored in `storage/`
- Added `sqlite3`, `solid_cache`, `solid_queue`, `solid_cable`; removed `pg`, `redis`
- `config/cable.yml` → `solid_cable`; added `config/cache.yml`, `config/queue.yml` and `db/{cable,cache,queue}_schema.rb`
- Production uses `:solid_cache_store` and the `:solid_queue` job adapter
- `storage` added to Capistrano `linked_dirs` so the SQLite files survive releases

### Materialized view → regular view (SQLite has no materialized views)
- `results_with_historical_data` is now a **regular** view (`db/views/results_with_historical_data_v03.sql`, migration `20260712000001`)
- The window-function SQL was translated for SQLite (`true`/`NULL::boolean` → `1`/`NULL`)
- Because a regular view is always live, the manual refresh was removed:
  `ResultWithHistoricalData.refresh`, the `Result` `after_commit` callback, and the refresh call in `EventsController#recalculate_results` are gone. The `recalculate_results` route/link now just redirects (kept as harmless, since results are always current).
- `db/schema.rb` was hand-edited to be SQLite-loadable: dropped `enable_extension "plpgsql"` and `create_enum "distances"`, changed `results.distance` to a plain string column, and made the view non-materialised.

## You must verify locally (Ruby 4.0.2)

1. `bundle install` to regenerate `Gemfile.lock`.
2. `bin/rails db:prepare` then `bin/rails test test:system` — full suite.
3. `bin/importmap json` / load a page using the searchable select to confirm tom-select works via importmap.
4. `bin/rails tailwindcss:build` and eyeball the styling.

### Known risk areas
- **`load_defaults` 7.0 → 8.1 in one jump** flips every intermediate default at once. If tests surface breakage, step through incrementally with `new_framework_defaults_7_1/7_2/8_0/8_1.rb` files instead.
- **Tailwind v3 → v4 utility renames** (`shadow`/`ring`/`rounded`/`outline-none`, bare-colour opacity syntax) are NOT auto-applied across templates. Run `npx @tailwindcss/upgrade` locally, or audit views, for pixel parity. The build itself compiles as-is.
- **`@plugin "@tailwindcss/forms"`** relies on the tailwindcss-ruby standalone binary bundling the forms plugin. Confirm `tailwindcss:build` succeeds; if not, inline the plugin CSS.
- **Postgres → SQLite is an engine switch, not just config.** Existing production data needs a real export/import. The legacy Postgres-only migrations must NOT be replayed on SQLite — set up the SQLite databases with `db:schema:load` (not `db:migrate` from zero).
- **Solid Queue** has no worker under Passenger. There are currently no background jobs, so it is dormant; wire up `bin/jobs` (or a systemd unit) before relying on Active Job in production.
- **Deploy still uses Passenger.** Moving to Puma (like ws10/daily-bread) was left out of this pass; raise it separately if you want it.
