class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:twitter, :facebook, :vkontakte, :github]

    has_many :questions
    has_many :answers
    has_many :identities

    def self.find_for_oauth(auth)
        identity = Identity.find_for_oauth(auth)
        return identity.user if identity # если существует авторизация, то возвращает пользователя

        return false unless auth.info[:email] # если не передается email, то в итоге редиректит на страницу подтверждения
        email = auth.info[:email]
        user = User.find_by(email: email)
        user = User.create!(email: email, password: Devise.friendly_token[0,20]) unless user # если не было пользователя для этой авторизации, то создается пользователь
        user.identities.create(provider: auth.provider, uid: auth.uid) # создается авторизация
        user
    end

    def self.send_daily_digest
        SendDailyDigestJob.perform_later(Question.today)
    end
end
