RSpec.describe AnswersController, type: :controller do
    let!(:question) { create :question }

    describe 'POST #create' do
        context 'Unauthorized user' do
            it 'cant create answers' do
                expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to_not change(Answer, :count)
            end
        end

        context 'Authorized user create answer' do
            sign_in_user

            context 'with valid attributes' do
                it 'saves the new answer in the DB' do
                    expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(question.answers, :count).by(1)
                end

                it 'belongs to current user' do
                    expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(@current_user.answers, :count).by(1)
                end

                it 'redirects to question show action' do
                    post :create, answer: attributes_for(:answer), question_id: question, format: :js

                    expect(response).to render_template :create
                end
            end

            context 'with invalid attributes' do
                it 'does not save the new answer in the DB' do
                    expect { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }.to_not change(Answer, :count)
                end

                it 'nothing not render' do
                    post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js

                    expect(response).to render_template :create
                end
            end
        end
    end

    describe 'POST #destroy' do
        let!(:answer_1) { create :answer, question: question }

        context 'Unauthorized user' do
            it 'cant delete answers' do
                expect { delete :destroy, id: answer_1, question_id: question, format: :js }.to_not change(Answer, :count)
            end
        end

        context 'Authorized user' do
            sign_in_user
            let!(:answer_2) { create :answer, question: question, user: @current_user }

            it 'can delete own answer' do
                expect { delete :destroy, id: answer_2, question_id: question, format: :js }.to change(Answer, :count).by(-1)
            end

            it 'cant delete answer of other user' do
                expect { delete :destroy, id: answer_1, question_id: question, format: :js }.to_not change(Answer, :count)
            end
        end
    end

    describe 'PATCH #update' do
        context 'Unauthorized user' do
            let!(:answer) { create :answer, question: question }

            it 'cant update answers' do
                expect { patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js }.to_not change{ answer }
            end
        end

        context 'Authorized user' do
            sign_in_user
            let!(:answer) { create :answer, question: question, user: @current_user }

            it 'assings the requested answer to @answer' do
                patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js

                expect(assigns(:answer)).to eq answer
            end

            it 'changes answer attributes' do
                patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: :js
                answer.reload

                expect(answer.body).to eq 'new body'
            end
        end
    end

    describe  'GET #best' do
        context 'Unauthorized user' do
            let!(:answer) { create :answer, question: question, best: false }

            it 'cant set best answers' do
                expect { get :best, id: answer, question_id: question, format: :js }.to_not change{ question.answers.where(best: true) }
            end
        end

        context 'Authorized user' do
            sign_in_user
            let!(:own_question) { create :question, user: @current_user }
            let!(:answer_1) { create :answer, question: own_question, best: false }
            let!(:other_question) { create :question }
            let!(:answer_2) { create :answer, question: other_question, best: false }

            it 'can set best answer for his question' do
                expect { xhr :get, :best, id: answer_1, question_id: own_question, format: :js }.to change{ own_question.answers.where(best: true).first }
            end

            it 'cant set best answer for other user question' do
                expect { xhr :get, :best, id: answer_2, question_id: other_question, format: :js }.to_not change{ other_question.answers.where(best: true).first }
            end
        end
    end
end
