# Stack modernisation — nw5k

This branch brings nw5k into line with the other apps (ws10, daily-bread):
Ruby 4, Rails 8.1 defaults, Propshaft, importmap, Tailwind v4, and
SQLite + Solid Cache/Queue/Cable, deployed under Puma.

> **Status:** the branch has now been verified locally on Ruby 4.0.2 —
> `bundle install`, app boot, `assets:precompile`, and a production Puma boot
> (with Solid Queue running) all succeed. `Gemfile.lock` has been regenerated
> and committed. The remaining unchecked boxes below are the ones that still
> need a human: interactive/visual checks, the system test suite, and the
> production data migration + server setup.

## What changed

### Ruby & framework
- `.ruby-version` → `4.0.2`; `Gemfile.lock` locked under Ruby 4.0.2 with the
  `arm64-darwin` platform added (needed for the native tailwindcss binary)
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
- tom-select's base CSS vendored at `app/assets/tailwind/tom-select.css` and imported via `@import "./tom-select.css"` (the explicit `./` is required — Tailwind v4's bundler treats a bare specifier as a package)
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

### Deploy: Passenger → Puma
- Removed `capistrano-passenger` and `require "capistrano/passenger"`
- Added `lib/capistrano/tasks/puma.rake`, which restarts the `puma-nw5k`
  systemd **user** service after `deploy:published`
- `set :rbenv_ruby` on the server updated to `4.0.2`
- **Solid Queue runs inside Puma** via `plugin :solid_queue` in `config/puma.rb`
  (gated on `RAILS_ENV=production`, with a `SOLID_QUEUE_IN_PUMA` override for
  other environments — dotenv-rails is not loaded in production, so an env flag
  alone would never activate there)

## Verified locally on Ruby 4.0.2 (this session)

- [x] `bundle install` resolves and installs; `Gemfile.lock` regenerated & committed
- [x] App boots (`bin/rails runner`) on the sqlite3 adapter — Rails 8.1.1 / Ruby 4.0.2
- [x] `bin/rails db:prepare` creates the primary DB (dev) and all four production DBs (primary/cache/queue/cable)
- [x] `bin/rails tailwindcss:build` succeeds; tom-select styles land in the output (`@tailwindcss/forms` bundles fine via the standalone binary)
- [x] `RAILS_ENV=production bin/rails assets:precompile` succeeds (Propshaft + importmap + Tailwind end-to-end)
- [x] Booting Puma in production starts the Solid Queue supervisor + dispatcher + worker, all registered in `solid_queue_processes`

## Still to do before merge

### Testing
- [ ] **Visual pass** of the Tailwind v3→v4 changes — especially destroy-button focus states (`focus:outline-hidden`) and tooltip shadows (`shadow-xs`)
- [ ] **Load a page with a searchable select** and confirm tom-select initialises and is styled (importmap path). `bin/importmap json` to sanity-check the pins.
- [ ] **`bin/rails test test:system`** — the system tests need Selenium/Chrome and were not run here. Note the repo currently has almost no test coverage (2 test files, 0 assertions), so these checks are largely manual.

### Deployment runbook
This is a **Postgres → SQLite engine switch**, so it is *not* a normal deploy —
production data must be migrated by hand and the server needs one-time setup.

1. **Export production data from Postgres first** (while the old app is still
   running). A schema-agnostic dump of the app tables (`people`, `events`,
   `results`, `admins`, `banners`, `volunteers`) — CSV per table or a Rails
   script — is safest. Do **not** try to replay the legacy Postgres-only
   migrations on SQLite.
2. **Deploy the branch** with Capistrano as usual. `capistrano-rails` runs
   `db:migrate`; because `storage/` is a linked dir, the SQLite files live in
   `shared/storage/`.
3. **Create the SQLite databases** on the server via `db:schema:load` /
   `db:prepare` (loads `schema.rb` + the `{cache,queue,cable}_schema.rb` files
   into the four databases) — **not** `db:migrate` from zero.
4. **Import the exported data** into the new primary SQLite DB.
5. **Server-side (one-time), outside this repo — personal-project box:**
   - Create a `puma-nw5k` systemd **user** service that runs
     `bundle exec puma -C config/puma.rb` with `RAILS_ENV=production` and the
     app's env (SECRET_KEY_BASE etc.); enable lingering so it survives logout.
     `lib/capistrano/tasks/puma.rake` expects exactly this unit name.
   - Remove/disable the old Passenger vhost so it no longer serves the app.
   - Point the web server / reverse proxy at Puma's port.
6. **Verify after cutover:** pages render, tom-select works, and background
   jobs process (enqueue a trivial job and watch `solid_queue_processes` /
   the queue DB).

### Known risk areas
- **`load_defaults` 7.0 → 8.1 in one jump** flips every intermediate default at once. With near-zero automated coverage this is the biggest unknown; if something misbehaves, step through incrementally with `new_framework_defaults_7_1/7_2/8_0/8_1.rb` files instead.
- **Postgres → SQLite is an engine switch, not just config.** See the runbook above — real export/import, and `db:schema:load` rather than replaying old migrations.
- **`.env.template`** still lists `NW5K_DATABASE_PASSWORD`, which is dead now that Postgres is gone — safe to drop when convenient.
