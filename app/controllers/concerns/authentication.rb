module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :current_person
    helper_method :current_person
    helper_method :person_signed_in?
  end

  def authenticate_person!
    store_location
    redirect_to login_path, alert: "You need to login to access that page." unless person_signed_in?
  end

  def forget(person)
    cookies.delete :remember_token
    person.regenerate_remember_token
  end

  def login(person)
    reset_session
    session[:current_person_id] = person.id
  end

  def logout
    reset_session
  end

  def redirect_if_authenticated
    redirect_to root_path, alert: "You are already logged in." if person_signed_in?
  end

  def remember(person)
    person.regenerate_remember_token
    cookies.permanent.encrypted[:remember_token] = person.remember_token
  end

  def store_location
    session[:return_to] = request.original_url if request.get? && request.local?
  end

  private

  def current_person
    Current.person ||= if session[:current_person_id].present?
      Person.find_by(id: session[:current_person_id])
    elsif cookies.permanent.encrypted[:remember_token].present?
      Person.find_by(remember_token: cookies.permanent.encrypted[:remember_token])
    end
  end

  def person_signed_in?
    Current.person.present?
  end
end
