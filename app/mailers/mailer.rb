class Mailer < ApplicationMailer
    def digest(user, questions)
        @questions = questions
        mail to: user.email, subject: 'Today questions'
    end

    def answer_create(answer)
        mail to: answer.question.user.email, subject: 'You get answer for your question'
    end

    def notify_subscribers(user, question)
        @question = question
        mail to: user.email, subject: 'Question that you subscribed has new answer'
    end
end
