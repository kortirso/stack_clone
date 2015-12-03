RSpec.describe Identity, type: :model do
    it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }
    it { should validate_presence_of :user_id }
    it { should belong_to :user }
end
