RSpec.describe Mailer, type: :mailer do
    describe 'digest' do
        let(:user) { create :user }
        let!(:questions) { create_list(:question, 2) }
        let(:mail) { Mailer.digest(user, questions) }

        it 'renders the headers' do
            expect(mail.subject).to eq('Today questions')
            expect(mail.to).to eq(["#{user.email}"])
            expect(mail.from).to eq(["from@example.com"])
        end

        it 'renders the body' do
            expect(mail.body.encoded).to match("#{questions[0].title}")
            expect(mail.body.encoded).to match("#{questions[1].title}")
        end
    end

    describe 'notify_subscribers' do
        let(:user) { create :user }
        let(:question) { create :question }
        let(:answer) { create :answer, user: user, question: question }
        let(:subscribe) { create :subscribe, subscribeable: question, user: user }
        let(:mail) { Mailer.notify_subscribers(user, answer) }

        it 'renders the headers' do
            expect(mail.subject).to eq('Question that you subscribed has new answer')
            expect(mail.to).to eq(["#{user.email}"])
            expect(mail.from).to eq(["from@example.com"])
        end

        it 'renders the body' do
            expect(mail.body.encoded).to match('Question that you subscribed has new answer')
            expect(mail.body.encoded).to match(question.title)
            expect(mail.body.encoded).to match(answer.body)
        end
    end
end
