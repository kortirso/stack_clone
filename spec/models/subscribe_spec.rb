RSpec.describe Subscribe, type: :model do
    it { should belong_to :user }
    it { should belong_to :subscribeable }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :subscribeable_id }
end
