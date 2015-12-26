require_relative 'feature_helper'

RSpec.feature "Question subscribing", :type => :feature do
    let!(:user) { create :user }
    let!(:question) { create :question }
    let!(:other_question) { create :question }
    let!(:subscribe) { create :subscribe, question: other_question, user: user }

     describe 'Unauthorized user' do
        it 'cant see subscribing button' do
            visit question_path(question)

            within '#question' do
                expect(page).to_not have_link 'Subscribe'
            end
        end
    end

    describe 'Authorized user' do
        before { sign_in user }

        context 'for question without his subscribe' do
            before { visit question_path(question) }

            it 'can see Subscribe button' do
                within "#question" do
                    expect(page).to have_link 'Subscribe'
                end
            end

            it 'and can click Subscribe button', js: true do
                within "#question" do
                    click_on 'Subscribe'

                    expect(page).to have_content 'You subscribe for email notifications, remove subscribe?'
                end
            end
        end

        context 'for question without his subscribe' do
            before { visit question_path(other_question) }

            it 'can see Desubscribe button' do
                within "#question" do
                    expect(page).to have_link 'Desubscribe'
                end
            end

            it 'and can click Desubscribe button', js: true do
                within "#question" do
                    click_on 'Desubscribe'

                    expect(page).to have_content 'Subscribe to question and get emails when users make answers'
                end
            end
        end
    end
end