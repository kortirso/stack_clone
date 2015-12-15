class Ability
    include CanCan::Ability

    attr_reader :user

    def initialize(user)
        @user = user
        if user
            user.admin? ? admin_abilities : user_abilities
        else
            guest_abilities
        end
    end

    def guest_abilities
        can :read, :all
    end

    def admin_abilities
        can :manage, :all
    end

    def user_abilities
        guest_abilities
        can :create, [Question, Answer, Comment]
        can :update, [Question, Answer], user: user
        can :destroy, [Question, Answer], user: user

        can :manage, Attachment, attachable: { user: user }

        alias_action :vote_plus, :vote_minus, :devote, to: :vote
        can :vote, [Question, Answer]
        cannot :vote, [Question, Answer], user: user

        can :best, Answer, question: { user: user }
    end
end
