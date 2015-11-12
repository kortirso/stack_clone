RSpec.describe AnswersController, type: :controller do
    describe 'POST #create' do
        sign_in_user
        let!(:question) { create :question, user: @current_user }

        context 'with valid attributes' do
            it 'saves the new answer in the DB' do
                expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(question.answers, :count).by(1)
            end

            it 'belongs to current user' do
                expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(@current_user.answers, :count).by(1)
            end

            it 'redirects to question show action' do
                post :create, answer: attributes_for(:answer), question_id: question

                expect(response).to redirect_to question
            end
        end

        context 'with invalid attributes' do
            it 'does not save the new answer in the DB' do
                expect { post :create, answer: attributes_for(:invalid_answer), question_id: question }.to_not change(Answer, :count)
            end

            it 'nothing not render' do
                post :create, answer: attributes_for(:invalid_answer), question_id: question

                expect(response).to redirect_to question
            end
        end
    end

    describe 'POST #destroy' do
        sign_in_user
        let!(:question) { create :question }
        let!(:answer_1) { create :answer, question: question, user: @current_user }
        let!(:answer_2) { create :answer, question: question }

        context 'own answer' do
            it 'deletes answer' do
                expect { delete :destroy, id: answer_1, question_id: question }.to change(Answer, :count).by(-1)
            end

            it 'redirects to answer question path' do
                delete :destroy, id: answer_1, question_id: question

                expect(response).to redirect_to answer_1.question
            end
        end

        context 'answer of other user' do
            it 'not delete answer' do
                expect { delete :destroy, id: answer_2, question_id: question }.to_not change(Answer, :count)
            end

            it 'redirects to question_path' do
                delete :destroy, id: answer_2, question_id: question

                expect(response).to redirect_to question
            end
        end
    end
end
