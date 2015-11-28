require_relative 'feature_helper'

RSpec.feature "Set best answer", :type => :feature do
    let!(:user) { create :user }
    let!(:question) { create :question, user: user }
    let!(:answer_1) { create :answer, question: question }
    let!(:answer_2) { create :answer, question: question }
    let!(:other_question) { create :question }
    let!(:other_answer) { create :answer, question: other_question }

    describe 'Unauthorized user' do
        it 'cant see set_best_button' do
            visit question_path(question)

            expect(page).to_not have_content 'Set best'
        end
    end

    describe 'Authorized user' do
        before { sign_in user }

        it 'can see set_best_button for his question' do
            visit question_path(question)

            expect(page).to have_content 'Set best'
        end

        context 'can set best answer for his question' do
            it 'by click on set_best_button', js: true do
                visit question_path(question)
                click_on "set_best_#{answer_1.id}"

                expect(page).to have_content 'Best answer'
            end

            it 'and cant set it again', js: true do
                visit question_path(question)
                click_on "set_best_#{answer_1.id}"

                expect(page).to_not have_css "#answers div:nth-child(2) .best_button"
            end

            it 'and this best answer would have first place answer', js: true do
                visit question_path(question)
                click_on "set_best_#{answer_2.id}"

                expect(page).to have_css "#answers div:nth-child(2) .answer #best_answer"
                expect(page).to have_css "#answers div:nth-child(2) .answer#answer-#{answer_2.id}"

                click_on "set_best_#{answer_1.id}"

                expect(page).to have_css "#answers div:nth-child(2) .answer#answer-#{answer_1.id}"
            end
        end

        it 'cant see set_best_button for other user answer' do
            visit question_path(other_question)

            expect(page).to_not have_content 'Set best'
        end
    end
end