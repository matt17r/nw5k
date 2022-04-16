class SessionsController < ApplicationController
  skip_before_action :authenticate_admin!, only: [:create, :new]
  before_action :redirect_if_authenticated, only: [:create, :new]

  def create
    @admin = Admin.find_by(email: params[:admin][:email].downcase)
    if @admin&.authenticate(params[:admin][:password])
      login @admin
      remember(@admin) if params[:admin][:rememember_me] == "1"
      puts "SessionsController.create:"
      puts "/tsession[:return_to] = #{session[:return_to]}"
      redirect_to session[:return_to] || root_path, notice: "Signed in."
    else
      flash.now[:alert] = "Incorrect email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    forget(current_admin)
    logout
    redirect_to root_path, notice: "Signed out."
  end

  def new
  end
end
