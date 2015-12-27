class SendToQuestionSubscribersJob < ActiveJob::Base
    queue_as :default

    def perform(answer)
        answer.question.subscribes.each do |subscribe|
            Mailer.notify_subscribers(subscribe.user, answer).deliver_later
        end
    end
end
