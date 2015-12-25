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

    describe 'answer_create' do
        let(:user) { create :user }
        let(:question) { create :question, user: user }
        let(:answer) { create :answer, user: user, question: question }
        let(:mail) { Mailer.answer_create(answer) }

        it 'renders the headers' do
            expect(mail.subject).to eq('You get answer for your question')
            expect(mail.to).to eq(["#{user.email}"])
            expect(mail.from).to eq(["from@example.com"])
        end

        it 'renders the body' do
            expect(mail.body.encoded).to match('Your question get answer')
        end
    end
end
