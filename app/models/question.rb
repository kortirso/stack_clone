class Question < ActiveRecord::Base
    include Voteable
    include Commentable

    has_many :answers, dependent: :destroy
    has_many :attachments, as: :attachable
    belongs_to :user

    scope :today, -> { where('created_at > ?', Time.current - 24.hours) }

    validates :title, :body, :user_id, presence: true

    accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
