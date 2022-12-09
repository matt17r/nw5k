class ApplicationController < ActionController::Base
  include Authentication
  before_action :authenticate_admin!
  before_action :check_rack_mini_profiler
  before_action :set_locale

  def check_rack_mini_profiler
    if admin_signed_in?
      Rack::MiniProfiler.authorize_request
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
