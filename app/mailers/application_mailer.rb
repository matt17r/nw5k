class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("noreply@nw5k.com", "New World 5k")
  layout "mailer"
end
