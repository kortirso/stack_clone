class Identity < ActiveRecord::Base
    belongs_to :user
    validates_presence_of :uid, :provider, :user_id
    validates_uniqueness_of :uid, :scope => :provider

    def self.find_for_oauth(auth)
        find_by(uid: auth.uid, provider: auth.provider)
    end
end
