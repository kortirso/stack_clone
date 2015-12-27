class Answer < ActiveRecord::Base
    include Voteable
    include Commentable

    belongs_to :question
    belongs_to :user
    has_many :attachments, as: :attachable

    validates :body, :question_id, :user_id, presence: true

    after_create :send_about_create

    accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

    def set_best
        Answer.transaction do
            question.answers.where(best: true).update_all(best: false)
            update!(best: true)
        end
    end

    private
    def send_about_create
        SendToQuestionSubscribersJob.perform_later(self)
    end
end
