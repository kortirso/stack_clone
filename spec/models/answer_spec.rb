RSpec.describe Answer, type: :model do
    it_behaves_like 'Main object'
    it_behaves_like 'voteable'

    it { should validate_presence_of :question_id }
    it { should belong_to :question }
end
