# Preview all emails at http://localhost:3000/rails/mailers/people_mailer
class PeopleMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/people_mailer/welcome_email
  def welcome_email
    PeopleMailer.with(person: Person.order(Arel.sql("RANDOM()")).first).welcome_email
  end
end
