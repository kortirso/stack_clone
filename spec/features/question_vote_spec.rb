require_relative 'feature_helper'

RSpec.feature "Question voting", :type => :feature do
    let!(:user) { create :user }
    let!(:question) { create :question }
    let!(:other_question) { create :question }
    let!(:vote) { create :vote, voteable: other_question, value: 1, user: user }

     describe 'Unauthorized user' do
        it 'cant see voting buttons' do
            visit question_path(question)

            within '#question' do
                expect(page).to_not have_content '+'
                expect(page).to_not have_content '-'
            end
        end
    end

    describe 'Authorized user' do
        before { sign_in user }

        context 'for question without his vote' do
            before { visit question_path(question) }

            it 'can see voting buttons' do
                within "#question" do
                    expect(page).to have_link '+'
                    expect(page).to have_link '-'
                end
            end

            it 'and can click + button', js: true do
                within "#question" do
                    click_on '+'

                    expect(page).to have_content 'Your vote: 1, remove vote?'
                end
            end

            it 'and can click - button', js: true do
                within "#question" do
                    click_on '-'

                    expect(page).to have_content 'Your vote: -1, remove vote?'
                end
            end
        end

        context 'for question with his vote' do
            before { visit question_path(other_question) }

            it 'can see remove button and cant vote second time' do
                within "#question" do
                    expect(page).to_not have_link '+'
                    expect(page).to_not have_link '-'
                    expect(page).to have_content 'remove vote?'
                end
            end

            it 'can click on the remove vote', js: true do
                within "#question" do
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