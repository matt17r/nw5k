class PeopleMailer < ApplicationMailer
  def welcome_email
    @person = params[:person]

    mail to: email_address_with_name("m.ls@me.com", "Matthew"), subject: "Welcome!"
  end
end
