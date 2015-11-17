RSpec.feature "Question management", :type => :feature do
    describe 'Unauthorized user' do
        let!(:question) { create :question }
        let!(:answer) { create :answer, question: question }
        let!(:questions) { create_list(:question, 2) }

        it 'can view all question' do
            visit questions_path

            expect(page).to have_content questions[0].title
            expect(page).to have_content questions[1].title
        end

        it 'cant creates a question' do
            visit questions_path

            expect(page).to_not have_content 'Create question'
        end

        it 'can view question and its answers' do
            visit question_path(question)

            expect(page).to have_content question.title
            expect(page).to have_content answer.body
        end

        it 'cant answer to question' do
            visit question_path(question)

            expect(page).to_not have_content 'New answer body'
        end

        it 'cant delete questions' do
            visit question_path(question)

            expect(page).to_not have_content 'Delete question'
        end
    end

    describe 'Logged user' do
        let(:user_1) { create :user }
        let(:user_2) { create :user }
        let!(:question_1) { create :question, user: user_1 }
        let!(:question_2) { create :question, user: user_2 }
        let!(:answer_1) { create :answer, question: question_1, user: user_1 }
        let!(:answer_2) { create :answer, question: question_2, user: user_2 }
        before do
            sign_in user_1
        end

        context 'can try creates a question' do
            before do
                visit questions_path
                click_on 'Create question'
            end

           it 'with valid data' do
                fill_in 'question_title', with: question_1.title
                fill_in 'question_body', with: question_1.body
                click_on 'Ask'

                expect(page).to have_content question_1.title
                expect(page).to have_content question_1.body
                expect(page).to have_content 'Question save'
            end

            it 'with invalid data' do
                fill_in 'question_title', with: question_1.title
                click_on 'Ask'

                expect(page).to have_content 'Error, question doesnot save'
            end
        end

        context 'can try answer to question' do
            it 'with valid data', js: true do
                visit question_path(question_1)

                fill_in 'answer_body', with: 'testing'
                click_on 'Answer'

                within '#answers' do
                    expect(page).to have_content 'testing'
                end
            end

            it 'with invalid data', js: true do
                visit question_path(question_1)

                fill_in 'answer_body', with: ''
                click_on 'Answer'

                expect(page).to have_content "Error when create answer"
            end
        end

        context 'can delete own data like' do
            before { visit question_path(question_1) }

            it 'question' do
                click_on 'delete'

                expect(page).to have_content 'Question delete'
            end

            it 'answer' do
                click_on 'Delete answer'

                expect(page).to have_content 'Answer delete'
            end
        end

        context 'cant delete data of other users like' do
            before { visit question_path(question_2) }

            it 'question' do
                expect(page).to_not have_content 'Delete question'
            end

            it 'answer' do
                expect(page).to_not have_content 'Delete answer'
            end
        end
    end
end