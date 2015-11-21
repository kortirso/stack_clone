require_relative 'feature_helper'

RSpec.feature "Question attachments", :type => :feature do
    let!(:user) { create :user }

    describe 'When create question' do
        context 'user can' do
            before do
                sign_in user
                visit new_question_path
            end

            it 'add attachment', js: true do
                fill_in 'question_title', with: 'Question text'
                fill_in 'question_body', with: 'Question body'
                attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
                click_on 'Ask'

                expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
            end

            it 'add many attachments', js: true do
                fill_in 'question_title', with: 'Question text'
                fill_in 'question_body', with: 'Question body'
                page.all('#new_question input[type="file"]')[0].set("#{Rails.root}/spec/rails_helper.rb")
                click_on 'Add file'
                page.all('#new_question input[type="file"]')[1].set("#{Rails.root}/spec/spec_helper.rb")
                click_on 'Ask'

                within '#question' do
                    expect(page).to have_link 'rails_helper.rb'
                    expect(page).to have_link 'spec_helper.rb'
                end
            end
        end
    end

    describe 'When visit question' do
        let!(:simple) { create :question, user: user }
        let!(:question) { create :question_with_attachment, user: user }
        let!(:other_question) { create :question_with_attachment }
        before do
            sign_in user
        end

        context 'user can' do
            before do
                visit question_path(simple)
                click_on 'Edit question'
            end

            it 'add attachment to his question', js: true do
                within "#question" do
                    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
                    click_on 'Save'

                    expect(page).to have_link 'spec_helper.rb'
                end
            end

            it 'cancel adding attachment to his question', js: true do
                within "#question" do
                    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
                    click_on 'Cancel'

                    expect(page).to_not have_link 'spec_helper.rb'
                end
            end

            it 'delete attachments of his question', js: true do
                within "#question" do
                    click_on 'Remove file'
                    click_on 'Save'

                    expect(page).to_not have_css '.attachments ul li'
                end
            end

            it 'cancel deleting attachments of his question', js: true do
                within "#question" do
                    click_on 'Remove file'
                    click_on 'Cancel'

                    expect(page).to_not have_link 'spec_helper.rb'
                end
            end
        end

        it 'user cant delete attachments of other user question', js: true do
            visit question_path(other_question)

            within '#question' do
                expect(page).to_not have_link 'Edit question'
            end
        end
    end
end