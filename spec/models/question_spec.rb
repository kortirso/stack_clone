RSpec.describe Question, type: :model do
    it_behaves_like 'Main object'
    it_behaves_like 'voteable'

    it { should validate_presence_of :title }
    it { should have_many(:answers).dependent(:destroy) }
end
