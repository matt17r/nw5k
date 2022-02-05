class WelcomeController < ApplicationController
  skip_before_action :authenticate_person!, only: :index
end
