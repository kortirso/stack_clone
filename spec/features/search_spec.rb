require_relative 'feature_helper'
require_relative 'sphinx_helper'

RSpec.feature 'Search text', type: :feature do
    let!(:user) { create :user }
    let!(:question) { create :question, body: 'job question' }
    let!(:answer) { create :answer, question: question, body: 'job answer' }
    let!(:comment) { create :comment, commentable: answer, body: 'job comment' }
    let!(:other_user) { create :user, email: 'other@email.com' }
    let!(:other_question) { create :question, body: 'simple question', user: user }
    let!(:other_answer) { create :answer, question: other_question, body: 'simple answer' }
    let!(:other_comment) { create :comment, commentable: other_answer, body: 'simple comment' }
    before do
        index
        visit root_path
    end

    describe 'show page with search results for query' do
        before do
            click_on 'Search'
            within '#search_form' do
                fill_in 'search_query', with: 'job'
            end
        end

        it 'for all objects', js: true do
            choose('All objects')
            click_on 'Start search'

            within '#search_results' do
                expect(page).to have_content "You try to find - job"
                expect(page).to have_content "You choose option - #1"
                expect(page).to have_content 'System find 3 objects'
                expect(page).to have_content "Question body - #{question.body}"
                expect(page).to have_content "Answer body - #{answer.body}"
                expect(page).to have_content "Comment body - #{comment.body}"
                expect(page).to_not have_content "User email - #{user.email}"
                expect(page).to_not have_content "Other question body - #{other_question.body}"
                expect(page).to_not have_content "Other answer body - #{other_answer.body}"
                expect(page).to_not have_content "Other comment body - #{other_comment.body}"
                expect(page).to_not have_content "User email - #{other_user.email}"
            end
        end

        it 'for question objects', js: true do
            choose('At questions')
            click_on 'Start search'

            within '#search_results' do
                expect(page).to have_content "You try to find - job"
                expect(page).to have_content "You choose option - #2"
                expect(page).to have_content 'System find 1 objects'
                expect(page).to have_content "Question body - #{question.body}"
                expect(page).to_not have_content "Answer body - #{answer.body}"
                expect(page).to_not have_content "Comment body - #{comment.body}"
                expect(page).to_not have_content "User email - #{user.email}"
                expect(page).to_not have_content "Other question body - #{other_question.body}"
                expect(page).to_not have_content "Other answer body - #{other_answer.body}"
                expect(page).to_not have_content "Other comment body - #{other_comment.body}"
                expect(page).to_not have_content "User email - #{other_user.email}"
            end
        end

        it 'for answer objects', js: true do
            choose('At answers')
            click_on 'Start search'

            within '#search_results' do
                expect(page).to have_content "You try to find - job"
                expect(page).to have_content "You choose option - #3"
                expect(page).to have_content 'System find 1 objects'
                expect(page).to_not have_content "Question body - #{question.body}"
                expect(page).to have_content "Answer body - #{answer.body}"
                expect(page).to_not have_content "Comment body - #{comment.body}"
                expect(page).to_not have_content "User email - #{user.email}"
                expect(page).to_not have_content "Other question body - #{other_question.body}"
                expect(page).to_not have_content "Other answer body - #{other_answer.body}"
                expect(page).to_not have_content "Other comment body - #{other_comment.body}"
                expect(page).to_not have_content "User email - #{other_user.email}"
            end
        end

        it 'for comment objects', js: true do
            choose('At comments')
            click_on 'Start search'

            within '#search_results' do
                expect(page).to have_content "You try to find - job"
                expect(page).to have_content "You choose option - #4"
                expect(page).to have_content 'System find 1 objects'
                expect(page).to_not have_content "Question body - #{question.body}"
                expect(page).to_not have_content "Answer body - #{answer.body}"
                expect(page).to have_content "Comment body - #{comment.body}"
                expect(page).to_not have_content "User email - #{user.email}"
                expect(page).to_not have_content "Other question body - #{other_question.body}"
                expect(page).to_not have_content "Other answer body - #{other_answer.body}"
                expect(page).to_not have_content "Other comment body - #{other_comment.body}"
                expect(page).to_not have_content "User email - #{other_user.email}"
            end
        end

        it 'for users objects', js: true do
            within '#search_form' do
                fill_in 'search_query', with: user.email
                choose('At users')
            end
            click_on 'Start search'

            within '#search_results' do
                expect(page).to have_content "You try to find - #{user.email}"
                expect(page).to have_content "You choose option - #5"
                expect(page).to have_content 'System find 1 objects'
                expect(page).to_not have_content "Question body - #{question.body}"
                expect(page).to_not have_content "Answer body - #{answer.body}"
                expect(page).to_not have_content "Comment body - #{comment.body}"
                expect(page).to have_content "User email - #{user.email}"
                expect(page).to_not have_content "Other question body - #{other_question.body}"
                expect(page).to_not have_content "Other answer body - #{other_answer.body}"
                expect(page).to_not have_content "Other comment body - #{other_comment.body}"
                expect(page).to_not have_content "User email - #{other_user.email}"
            end
        end

        it 'for empty objects', js: true do
            click_on 'Start search'

            within '#search_results' do
                expect(page).to have_content "You try to find - job"
                expect(page).to have_content "You choose option - #"
                expect(page).to have_content 'System find 3 objects'
                expect(page).to have_content "Question body - #{question.body}"
                expect(page).to have_content "Answer body - #{answer.body}"
                expect(page).to have_content "Comment body - #{comment.body}"
                expect(page).to_not have_content "User email - #{user.email}"
                expect(page).to_not have_content "Other question body - #{other_question.body}"
                expect(page).to_not have_content "Other answer body - #{other_answer.body}"
                expect(page).to_not have_content "Other comment body - #{other_comment.body}"
                expect(page).to_not have_content "User email - #{other_user.email}"
            end
        end
    end

    describe 'for empty query' do
        before { click_on 'Search' }

        it 'show page with no search results', js: true do
            click_on 'Start search'

            expect(page).to have_content 'System doesnt find anything'
        end
    end
end