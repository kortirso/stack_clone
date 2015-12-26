class SendToQuestionSubscribersJob < ActiveJob::Base
    queue_as :default

    def perform(question)
        question.subscribes.find_each.each do |subscribe|
            Mailer.notify_subscribers(subscribe.user, question).deliver_later
        end
    end
end
