class Answer < ActiveRecord::Base
    belongs_to :question
    belongs_to :user

    validates :body, :question_id, :user_id, presence: true

    def set_best
        Answer.transaction do
            question.answers.where(best: true).update_all(best: false)
            update_attributes(best: true)
        end
    end
end
