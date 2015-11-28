require_relative 'feature_helper'

RSpec.feature "Answer voting", :type => :feature do
    let!(:user) { create :user }
    let!(:question) { create :question }
    let!(:answer) { create :answer, question: question }
    let!(:other_answer) { create :answer, question: question }
    let!(:vote) { create :vote, voteable: other_answer, value: 1, user: user }

     describe 'Unauthorized user' do
        it 'cant see voting buttons' do
            visit question_path(question)

            expect(page).to_not have_content '+'
            expect(page).to_not have_content '-'
        end
    end

    describe 'Authorized user' do
        before do
            sign_in user
            visit question_path(question)
        end

        context 'for answer without his vote' do
            it 'can see voting buttons' do
                within "#answer-#{answer.id}" do
                    expect(page).to have_link '+'
                    expect(page).to have_link '-'
                end
            end

            it 'and can click + button', js: true do
                within "#answer-#{answer.id}" do
                    click_on '+'

                    expect(page).to have_content 'Your vote: 1, remove vote?'
                end
            end

            it 'and can click - button', js: true do
                within "#answer-#{answer.id}" do
                    click_on '-'

                    expect(page).to have_content 'Your vote: -1, remove vote?'
                end
            end
        end

        context 'for answer with his vote' do
            it 'can see remove button and cant vote second time' do
                within "#answer-#{other_answer.id}" do
                    expect(page).to_not have_link '+'
                    expect(page).to_not have_link '-'
                    expect(page).to have_content 'remove vote?'
                end
            end

            it 'can click on the remove vote', js: true do
                within "#answer-#{other_answer.id}" do
                    page.all('.votes_block a')[0].click

                    expect(page).to have_link '+'
                    expect(page).to have_link '-'
                    expect(page).to_not have_content 'remove vote?'
                    expect(page).to have_content 'Оценка 0'
                end
            end
        end
    end
end