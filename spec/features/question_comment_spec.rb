require_relative 'feature_helper'

RSpec.feature "Add comment to question", :type => :feature do
    let!(:user) { create :user }
    let!(:question) { create :question }

     describe 'Unauthorized user' do
        it 'cant see add_comment form' do
            visit question_path(question)

            within '#question' do
                expect(page).to_not have_css '#comment_body'
            end
        end
    end

    describe 'Authorized user' do
        before { sign_in user }

        context 'for question' do
            before { visit question_path(question) }

            it 'can see add_comment form' do
                within "#question" do
                    expect(page).to have_css '#comment_body'
                end
            end

            it 'and can add_comment', js: true do
                within "#question" do
                    fill_in 'comment_body', with: 'new comment'
                    click_on 'Add comment'

                    expect(page).to have_content 'new comment'
                end
            end
        end
    end
end