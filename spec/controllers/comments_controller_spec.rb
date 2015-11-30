RSpec.describe CommentsController, type: :controller do
    describe 'POST #create' do
        let!(:question) { create :question }
        let!(:answer) { create :answer, question: question }

        context 'Unauthorized user' do
            it 'cant add comment to question' do
                expect { post :create, question_id: question, comment: attributes_for(:comment_for_question), commentable: 'questions', format: :js }.to_not change(Comment, :count)
            end

            it 'cant add comment to answer' do
                expect { post :create, question_id: question, answer_id: answer, comment: attributes_for(:comment_for_answer), commentable: 'answers', format: :js }.to_not change(Comment, :count)
            end
        end

        context 'Authorized user' do
            sign_in_user

            context 'can add comment with valid attributes' do
                it 'to question' do
                    expect { post :create, question_id: question, comment: attributes_for(:comment_for_question), commentable: 'questions', format: :js }.to change(question.comments, :count)
                end

                it 'to answer' do
                    expect { post :create, question_id: question, answer_id: answer, comment: attributes_for(:comment_for_answer), commentable: 'answers', format: :js }.to change(answer.comments, :count)
                end
            end

            context 'cant add comment with invalid attributes' do
                it 'to question' do
                    expect { post :create, question_id: question, comment: attributes_for(:comment_for_question, :mistake), commentable: 'questions', format: :js }.to_not change(Comment, :count)
                end

                it 'to answer' do
                    expect { post :create, question_id: question, answer_id: answer, comment: attributes_for(:comment_for_answer, :mistake), commentable: 'answers', format: :js }.to_not change(Comment, :count)
                end
            end
        end
    end
end



