class PagesController < ApplicationController
  skip_before_action :authenticate_admin!, except: [:admin]

  def admin
    @recent_events = Event.order(number: :desc).limit(3).includes(:results)
    @recent_people = Person.order(created_at: :desc).limit(3)
    @recent_banners = Banner.order(created_at: :desc).limit(3)
  end
end
