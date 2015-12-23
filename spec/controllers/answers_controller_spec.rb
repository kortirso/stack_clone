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

                it_behaves_like 'Publishable' do
                    let(:path) { "/questions/#{question.id}/answers" }
                    let(:object) { post :create, answer: attributes_for(:answer), question_id: question, format: :js }
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
                expect { get :best, id: answer, question_id: question, format: :js }.to_not change(question.answers.where(best: true), :count)
            end
        end

        context 'Authorized user' do
            sign_in_user
            let!(:own_question) { create :question, user: @current_user }
            let!(:answer_1) { create :answer, question: own_question, best: false }
            let!(:answer_2) { create :answer, question: own_question, best: true }
            let!(:other_question) { create :question }
            let!(:answer_3) { create :answer, question: other_question, best: false }

            it 'can set best answer for his question' do
                expect { xhr :get, :best, id: answer_1, question_id: own_question, format: :js }.to_not change(own_question.answers.where(best: true), :count)
            end

            it 'cant set best answer for other user question' do
                expect { xhr :get, :best, id: answer_2, question_id: other_question, format: :js }.to_not change(other_question.answers.where(best: true), :count)
            end
        end
    end

    describe 'POST #vote_plus' do
        context 'Unauthorized user' do
            let!(:answer) { create :answer, question: question }

            it 'cant vote for answer' do
                expect { post :vote_plus, question_id: question, id: answer }.to_not change(Vote, :count)
            end
        end

        context 'Authorized user' do
            sign_in_user
            let!(:answer) { create :answer, question: question, user: @current_user }
            let!(:other_answer) { create :answer, question: question }

            it 'can vote for other_answer' do
                expect { post :vote_plus, question_id: question, id: other_answer }.to change(other_answer.votes, :count)
            end

            it 'and other_answer has votes sum' do
                post :vote_plus, question_id: question, id: other_answer

                expect(other_answer.votes_calc).to eq 1
            end

            it 'but he cant vote twice' do
                create :vote, voteable: other_answer, user: @current_user
                post :vote_plus, question_id: question, id: other_answer

                expect(other_answer.votes_calc).to eq 1
            end

            it 'cant vote for his answer' do
                expect { post :vote_plus, question_id: question, id: answer }.to_not change(answer.votes, :count)
            end
        end
    end

    describe 'POST #vote_minus' do
        context 'Unauthorized user' do
            let!(:answer) { create :answer, question: question }

            it 'cant vote for answer' do
                expect { post :vote_minus, question_id: question, id: answer }.to_not change(Vote, :count)
            end
        end

        context 'Authorized user' do
            sign_in_user
            let!(:answer) { create :answer, question: question, user: @current_user }
            let!(:other_answer) { create :answer, question: question }

            it 'can vote for other_answer' do
                expect { post :vote_minus, question_id: question, id: other_answer }.to change(other_answer.votes, :count)
            end

            it 'and other_answer has votes sum' do
                post :vote_minus, question_id: question, id: other_answer

                expect(other_answer.votes_calc).to eq -1
            end

            it 'but he cant vote twice' do
                create :vote, voteable: other_answer, user: @current_user
                post :vote_minus, question_id: question, id: other_answer

                expect(other_answer.votes_calc).to eq -1
            end

            it 'cant vote for his answer' do
                expect { post :vote_minus, question_id: question, id: answer }.to_not change(Vote, :count)
            end
        end
    end

    describe 'POST #devote' do
        context 'Unauthorized user' do
            let!(:answer) { create :answer, question: question }

            it 'cant devote answer' do
                expect { post :devote, question_id: question, id: answer }.to_not change(Vote, :count)
            end
        end

        context 'Authorized user' do
            sign_in_user
            let!(:answer) { create :answer, question: question }
            let!(:other_answer) { create :answer, question: question }
            let!(:vote) { create :vote, voteable: answer, user: @current_user}

            it 'can devote for answer with his vote' do
                expect { post :devote, question_id: question, id: answer }.to change(answer.votes, :count)
            end

            it 'and answer has zero votes sum' do
                post :devote, question_id: question, id: answer

                expect(answer.votes_calc).to eq 0
            end

            it 'and then vote one more time' do
                post :devote, question_id: question, id: answer
                post :vote_plus, question_id: question, id: answer, user: @current_user

                expect(answer.votes_calc).to eq 1
            end

            it 'cant devote for answer without his vote' do
                expect { post :devote, question_id: question, id: other_answer }.to_not change(Vote, :count)
            end
        end
    end
end
