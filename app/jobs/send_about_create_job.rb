class SendAboutCreateJob < ActiveJob::Base
    queue_as :default

    def perform(answer)
        Mailer.answer_create(answer).deliver_later
    end
end
