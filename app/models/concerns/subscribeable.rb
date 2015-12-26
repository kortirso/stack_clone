module Subscribeable
    extend ActiveSupport::Concern

    included do
        has_many :subscribes, dependent: :destroy
    end

    def is_subscribe?(user)
        subscribes.find_by(user: user) ? true : false
    end

    def desubscribe(user)
        subscribe = subscribes.find_by(user: user)
        if subscribe
            subscribe.destroy
            return true
        end
        false
    end

    def subscribe(user)
        subscribe = subscribes.find_or_create_by(user: user)
    end
end