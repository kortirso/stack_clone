RSpec.describe SendDailyDigestJob, type: :job do
    let(:users) { create_list(:user, 2) }
    let!(:questions) { create_list(:question, 2, user: users.first) }

    it 'should send daily digest to all users' do
        users.each { |user| expect(Mailer).to receive(:digest).with(user, questions).and_call_original }
        SendDailyDigestJob.perform_now(questions)
    end
end
