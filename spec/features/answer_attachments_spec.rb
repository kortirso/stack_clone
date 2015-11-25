require_relative 'feature_helper'

RSpec.feature "Answer attachments", :type => :feature do
    let!(:user) { create :user }
    let!(:question) { create :question }

    describe 'When create answer' do
        context 'user can' do
            before do
                sign_in user
                visit question_path(question)
            end

            it 'add attachment', js: true do
                fill_in 'answer_body', with: 'Answer body'
                attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
                click_on 'Answer'

                within '#answers' do
                    expect(page).to have_link 'rails_helper.rb'
                end
            end

            it 'add many attachments', js: true do
                fill_in 'answer_body', with: 'Answer body'
                page.all('#new_answer input[type="file"]')[0].set("#{Rails.root}/spec/rails_helper.rb")
                click_on 'Add file'
                page.all('#new_answer input[type="file"]')[1].set("#{Rails.root}/spec/spec_helper.rb")
                click_on 'Answer'

                within '#answers' do
                    expect(page).to have_link 'rails_helper.rb'
                    expect(page).to have_link 'spec_helper.rb'
                end
            end
        end
    end

    describe 'When visit question' do
        let!(:answer) { create :answer_with_attachment, user: user, question: question }
        let!(:other_answer) { create :answer_with_attachment, question: question }
        before do
            sign_in user
            visit question_path(question)
        end

        context 'user can' do
            before do
                within "#answer-#{answer.id}" do
                    click_on 'Edit answer'
                end
            end

            it 'add attachment to his answer', js: true do
                within "#answer-#{answer.id}" do
                    click_on 'Add file'
                    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
                    click_on 'Save'

                    expect(page).to have_link 'rails_helper.rb'
                    expect(page).to have_link 'spec_helper.rb'
                end
            end

            it 'cancel adding attachment to his answer', js: true do
                within "#answer-#{answer.id}" do
                    click_on 'Add file'
                    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
                    click_on 'Cancel'

                    expect(page).to have_link 'rails_helper.rb'
                    expect(page).to_not have_link 'spec_helper.rb'
                end
            end

            it 'delete attachments of his answer', js: true do
                within "#answer-#{answer.id}" do
                    click_on 'Remove file'
                    click_on 'Save'

                    expect(page).to_not have_link 'rails_helper.rb'
                end
            end

            it 'cancel deleting attachments of his answer', js: true do
                within "#answer-#{answer.id}" do
                    click_on 'Remove file'
                    click_on 'Cancel'

                    expect(page).to have_link 'rails_helper.rb'
                end
            end
        end

        it 'user cant delete attachments of other user answer', js: true do
            within "#answer-#{other_answer.id}" do
                expect(page).to_not have_link 'Edit answer'
            end
        end
    end
end
