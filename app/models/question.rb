class Question < ActiveRecord::Base
    include Voteable
    include Commentable
    include Subscribeable

    has_many :answers, dependent: :destroy
    has_many :attachments, as: :attachable
    belongs_to :user

    scope :today, -> { where('created_at > ? AND created_at < ?', Time.current.beginning_of_day - 24.hours, Time.current.beginning_of_day) }

    validates :title, :body, :user_id, presence: true

    accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

    after_create :set_subscribe

    private
    def set_subscribe
        self.subscribe(self.user)
    end
end
