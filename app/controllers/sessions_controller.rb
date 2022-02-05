class SessionsController < ApplicationController
  skip_before_action :authenticate_person!, only: [:create, :new]
  before_action :redirect_if_authenticated, only: [:create, :new]

  def create
    @person = Person.find_by(email: params[:person][:email].downcase)
    if @person&.authenticate(params[:person][:password])
      after_login_path = session[:return_to] || root_path
      login @person
      remember(@person) if params[:person][:rememember_me] == "1"
      redirect_to after_login_path, notice: "Signed in."
    else
      flash.now[:alert] = "Incorrect email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    forget(current_person)
    logout
    redirect_to root_path, notice: "Signed out."
  end

  def new
  end
end
