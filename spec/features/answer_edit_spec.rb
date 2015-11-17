require_relative 'feature_helper'

RSpec.feature "Answer editing", :type => :feature do
    let!(:user) { create :user }
    let!(:question) { create :question }
    let!(:answer) { create :answer, question: question, user: user, body: 'First answer' }
    let!(:other_answer) { create :answer, question: question, body: 'Second answer' }

    describe 'Unauthorized user' do
        it 'cant see edit button' do
            visit question_path(question)

            expect(page).to_not have_content 'Edit answer'
        end
    end

    describe 'Authorized user' do
        before do
            sign_in user
            visit question_path(question)
        end

        it 'can see edit button for edit his answer' do
            expect(page).to have_css "##{answer.id}"
        end

        it 'try to edit his answer', js: true do
            click_on "Edit answer"
            within '.edit_answer' do
                fill_in 'answer_body', with: 'new body'
            end
            click_on 'Save'

            expect(page).to_not have_content answer.body
            expect(page).to have_content 'new body'
            expect(page).to_not have_css "#edit_answer_#{answer.id}"
        end

        it 'cant see edit button for other user answer' do
            expect(page).to_not have_css "##{other_answer.id}"
        end
    end
end