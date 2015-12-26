RSpec.describe Answer, type: :model do
    it { should validate_presence_of :body }
    it { should validate_presence_of :user_id }
    it { should belong_to :user }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many :attachments }
    it { should accept_nested_attributes_for :attachments }
    it { should validate_presence_of :question_id }
    it { should belong_to :question }

    it_behaves_like 'voteable'

    describe '.send_about_create' do
        let(:user) { create :user }
        let(:question) { create :question, user: user }
        let(:subscribe) { create :subscribe, question: question, user: user }
        subject { build :answer, question: question, user: user }

        context 'should' do
            it 'perform_later job SendAboutCreate' do
                expect(SendAboutCreateJob).to receive(:perform_later).with(subject)
                subject.save!
            end

            it 'perform_later job SendToQuestionSubscribers' do
                expect(SendToQuestionSubscribersJob).to receive(:perform_later).with(question)
                subject.save!
            end
        end
    end
end
