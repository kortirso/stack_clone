RSpec.describe Question, type: :model do
    it { should validate_presence_of :body }
    it { should validate_presence_of :user_id }
    it { should belong_to :user }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many :attachments }
    it { should accept_nested_attributes_for :attachments }
    it { should validate_presence_of :title }
    it { should have_many(:answers).dependent(:destroy) }

    it_behaves_like 'voteable'
end
