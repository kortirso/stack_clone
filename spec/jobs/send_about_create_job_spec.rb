RSpec.describe SendAboutCreateJob, type: :job do
    let(:answer) { create :answer }

    it 'should send email to creator of question after answer creating' do
        expect(Mailer).to receive(:answer_create).with(answer).and_call_original
        SendAboutCreateJob.perform_now(answer)
    end
end
