class Mailer < ApplicationMailer
    def digest(user, questions)
        @questions = questions
        mail to: user.email, subject: 'Today questions'
    end

    def notify_subscribers(user, answer)
        @answer = answer
        mail to: user.email, subject: 'Question that you subscribed has new answer'
    end
end
