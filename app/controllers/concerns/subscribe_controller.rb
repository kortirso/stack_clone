module SubscribeController
    extend ActiveSupport::Concern

    included do
        before_action :find_subscribe, only: [:subscribe, :unsubscribe]
    end

    def subscribe
        @subscribe_object.subscribe(current_user)
    end

    def unsubscribe
        @subscribe_object.unsubscribe(current_user)
    end

    private
    def find_subscribe
        @subscribe_object = controller_name.classify.constantize.find(params[:id])
    end
end