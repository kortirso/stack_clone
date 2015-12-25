class SendDailyDigestJob < ActiveJob::Base
    queue_as :default

    def perform(questions)
        User.find_each.each do |user|
            Mailer.digest(user, questions).deliver_later
        end
    end
end
