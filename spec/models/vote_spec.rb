RSpec.describe Vote, type: :model do
    it { should validate_presence_of :value }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :voteable_id }
    it { should validate_numericality_of :value }
    it { should belong_to :user }
    it { should belong_to :voteable }
end
