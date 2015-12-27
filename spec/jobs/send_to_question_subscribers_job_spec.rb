RSpec.describe SendToQuestionSubscribersJob, type: :job do
    let(:user) { create :user }
    let(:question) { create :question, user: user }
    let(:answer) { create :answer, question: question }

    it 'should send email to subscribers of question after answer creating' do
        expect(Mailer).to receive(:notify_subscribers).with(question.subscribes.last.user, answer).and_call_original
        SendToQuestionSubscribersJob.perform_now(answer)
    end
end
