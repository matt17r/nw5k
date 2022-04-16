module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :current_admin
    helper_method :current_admin
    helper_method :admin_signed_in?
  end

  def authenticate_admin!
    store_location
    redirect_to login_path, alert: "You need to login to access that page." unless admin_signed_in?
  end

  def forget(admin)
    cookies.delete :remember_token
    admin.regenerate_remember_token
  end

  def login(admin)
    reset_session
    session[:current_admin_id] = admin.id
  end

  def logout
    reset_session
  end

  def redirect_if_authenticated
    redirect_to root_path, alert: "You are already logged in." if admin_signed_in?
  end

  def remember(admin)
    admin.regenerate_remember_token
    cookies.permanent.encrypted[:remember_token] = admin.remember_token
  end

  def store_location
    session[:return_to] = request.original_url if request.get? && request.local?
    puts("*" * 30)
    puts "store_location:"
    puts "  session[:return_to] = #{session[:return_to]}"
    puts "  request.get? = #{request.get?}"
    puts "  request.local? = #{request.local?}"
    puts("*" * 30)
  end

  private

  def current_admin
    Current.admin ||= if session[:current_admin_id].present?
      Admin.find_by(id: session[:current_admin_id])
    elsif cookies.permanent.encrypted[:remember_token].present?
      Admin.find_by(remember_token: cookies.permanent.encrypted[:remember_token])
    end
  end

  def admin_signed_in?
    Current.admin.present?
  end
end
