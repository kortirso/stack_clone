RSpec.describe Ability, type: :model do
    subject(:ability) { Ability.new(user) }

    describe 'for guest' do
        let(:user) { nil }

        it { should be_able_to :read, Question }
        it { should be_able_to :read, Answer }
        it { should be_able_to :read, Comment }

        it { should_not be_able_to :create, :all }
        it { should_not be_able_to :update, :all }
        it { should_not be_able_to :destroy, :all }

        it { should_not be_able_to :manage, :all }
    end

    describe 'for admin' do
        let(:user) { create :user, :admin }

        it { should be_able_to :manage, :all }
    end

    describe 'for user' do
        let!(:user) { create :user }
        let!(:other_user) { create :user }
        let!(:question) { create :question, user: user }
        let!(:other_question) { create :question, user: other_user }
        let!(:answer) { create :answer, question: question, user: user }
        let!(:other_answer) { create :answer, question: other_question, user: other_user }
        let!(:attachment) { create :attachment, attachable: question }

        it { should be_able_to :read, :all }

        it { should be_able_to :create, Question }
        it { should be_able_to :create, Answer }
        it { should be_able_to :create, Comment }

        it { should be_able_to :update, question, user: user }
        it { should be_able_to :update, answer, user: user }
        it { should_not be_able_to :update, other_question, user: user }
        it { should_not be_able_to :update, other_answer, user: user }

        it { should be_able_to :destroy, question, user: user }
        it { should be_able_to :destroy, answer, user: user }
        it { should_not be_able_to :destroy, other_question, user: user }
        it { should_not be_able_to :destroy, other_answer, user: user }

        it { should be_able_to :manage, attachment, user: user }
        it { should_not be_able_to :manage, create(:attachment) }

        it { should be_able_to :vote, other_question, user: user }
        it { should_not be_able_to :vote, question, user: user }
        it { should be_able_to :vote, other_answer, user: user }
        it { should_not be_able_to :vote, answer, user: user }

        it { should be_able_to :best, answer, user: user }
        it { should_not be_able_to :best, create(:answer), user: user }

        it { should_not be_able_to :manage, :all }
    end
end