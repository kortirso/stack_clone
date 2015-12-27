class Subscribe < ActiveRecord::Base
    belongs_to :user
    belongs_to :subscribeable, polymorphic: true

    validates :user_id, :subscribeable_id, presence: true
end
