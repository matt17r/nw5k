I18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.yml")]

I18n.available_locales = %i[en km ja zh]

I18n.default_locale = :en