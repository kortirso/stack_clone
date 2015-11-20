class Answer < ActiveRecord::Base
    belongs_to :question
    belongs_to :user

    validates :body, :question_id, :user_id, presence: true

    def self.set_best(best)
        Answer.transaction do
            where(best: true).update_all(best: false)
            find(best).update_attributes(best: true)
        end
    end
end
