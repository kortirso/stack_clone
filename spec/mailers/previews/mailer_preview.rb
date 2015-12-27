# Preview all emails at http://localhost:3000/rails/mailers/daily_mailer
class MailerPreview < ActionMailer::Preview
    # Preview this email at http://localhost:3000/rails/mailers/daily_mailer/digest
    def digest
        Mailer.digest
    end
end
