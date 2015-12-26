RSpec.describe SendToQuestionSubscribersJob, type: :job do
    let(:subscribe) { create :subscribe }

    it 'should send email to subscribers of question after answer creating' do
        expect(Mailer).to receive(:notify_subscribers).with(subscribe.user, subscribe.question).and_call_original
        SendToQuestionSubscribersJob.perform_now(subscribe.question)
    end
end
