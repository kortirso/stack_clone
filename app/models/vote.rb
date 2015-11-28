class Vote < ActiveRecord::Base
    belongs_to :user
    belongs_to :voteable, polymorphic: true

    validates :value, :user_id, :voteable_id, presence: true
    validates :value, numericality: true
end
