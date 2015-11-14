RSpec.describe User, type: :model do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should have_many :questions }
    it { should have_many :answers }

    describe 'User' do
        let(:user) { create :user }

        it 'should be invalid when sign up with existed email' do
            expect { create :user, email: user.email }.to raise_error(ActiveRecord::RecordInvalid)
        end
    end
end
