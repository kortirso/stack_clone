module Subscribeable
    extend ActiveSupport::Concern

    included do
        has_many :subscribes, as: :subscribeable, dependent: :destroy
    end

    def is_subscribe?(user)
        subscribes.where(user: user).exists?
    end

    def unsubscribe(user)
        subscribe = subscribes.find_by(user: user)
        if subscribe
            subscribe.destroy
            return true
        end
        false
    end

    def subscribe(user)
        subscribes.find_or_create_by(user: user)
    end
end