class Answer < ActiveRecord::Base
    belongs_to :question
    belongs_to :user

    validates :body, :question_id, :user_id, presence: true

    def self.set_worst
        old = where(best: true).first
        old.update_attributes(best: false) if old
    end

    def set_best
        self.best = true
        self.save!
    end
end
