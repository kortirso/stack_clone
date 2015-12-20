shared_examples_for 'Main object' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :user_id }
    it { should belong_to :user }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many :attachments }
    it { should accept_nested_attributes_for :attachments }

    describe 'voteable' do
        it_behaves_like 'voteable'
    end
end