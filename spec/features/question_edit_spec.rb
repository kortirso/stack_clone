require_relative 'feature_helper'

RSpec.feature "Question editing", :type => :feature do
    let!(:user) { create :user }
    let!(:question) { create :question, user: user }
    let!(:other_question) { create :question }

    describe 'Unauthorized user' do
        it 'cant see edit button' do
            visit question_path(question)

            expect(page).to_not have_content 'Edit question'
        end
    end

    describe 'Authorized user' do
        it 'can see edit button for edit his question' do
            sign_in user
            visit question_path(question)

            expect(page).to have_content 'Edit question'
        end

        it 'try to edit his question', js: true do
            sign_in user
            visit question_path(question)
            click_on 'Edit question'
            within '.edit_question' do
                fill_in 'question_title', with: 'new title'
                fill_in 'question_body', with: 'new body'
            end
            click_on 'Save'

            expect(page).to_not have_content question.title
            expect(page).to_not have_content question.body
            expect(page).to have_content 'new title'
            expect(page).to have_content 'new body'
            expect(page).to_not have_css '.edit_question'
        end

        it 'cannot see edit button for other user question' do
            sign_in user
            visit question_path(other_question)

            expect(page).to_not have_content 'Edit question'
        end
    end
end