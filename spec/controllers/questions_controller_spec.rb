RSpec.describe QuestionsController, type: :controller do
    describe 'GET #index' do
        let(:questions) { create_list(:question, 2) }
        before { get :index }

        it 'collect an array of all questions' do
            expect(assigns(:questions)).to match_array(questions)
        end

        it 'renders index view' do
            expect(response).to render_template :index
        end
    end

    describe 'GET #show' do
        let(:question) { create :question }
        before { get :show, id: question }

        it 'assigns the requested question to @question' do
            expect(assigns(:question)).to eq question
        end

        it 'assigns new answer to question' do
            expect(assigns(:answer)).to be_a_new(Answer)
        end

        it 'builds new attachment for answer' do
            expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
        end

        it 'renders show view' do
            expect(response).to render_template :show
        end
    end

    describe 'GET #new' do
        sign_in_user
        before { get :new }

        it 'assigns a new question to @question' do
            expect(assigns(:question)).to be_a_new(Question)
        end

        it 'builds new attachment for question' do
            expect(assigns(:question).attachments.first).to be_a_new(Attachment)
        end

        it 'renders new view' do
            expect(response).to render_template :new
        end
    end

    describe 'POST #create' do
        sign_in_user

        context 'with valid attributes' do
            it 'saves the new question in the DB and it belongs to current user' do
                expect { post :create, question: attributes_for(:question) }.to change(@current_user.questions, :count).by(1)
            end

            it 'redirects to show view' do
                post :create, question: attributes_for(:question)

                expect(response).to redirect_to question_path(assigns(:question))
            end
        end

        context 'with invalid attributes' do
            it 'does not save the new question in the DB' do
                expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
            end

            it 're-render new view' do
                post :create, question: attributes_for(:invalid_question)

                expect(response).to redirect_to questions_path
            end
        end
    end

    describe 'PATCH #update' do
        context 'Unauthorized user' do
            let!(:question) { create :question }

            it 'cant change question' do
                expect { patch :update, id: question, question: attributes_for(:question), format: :js }.to_not change{question}
            end
        end

        context 'Authorized user can try' do
            sign_in_user
            let!(:question_1) { create :question, user: @current_user }
            let!(:question_2) { create :question }

            context 'change own question' do
                it 'assigns the requested question to @question' do
                    patch :update, id: question_1, question: attributes_for(:question), format: :js

                    expect(assigns(:question)).to eq question_1
                end

                it 'with valid attributes changes question' do
                    patch :update, id: question_1, question: { title: 'new title', body: 'new body' }, format: :js
                    question_1.reload

                    expect(question_1.title).to eq 'new title'
                    expect(question_1.body).to eq 'new body'
                end

                it 'with invalid attributes doesnt changes question' do
                    expect { patch :update, id: question_1, question: { title: '' }, format: :js }.to_not change(question_1, :title)
                    expect { patch :update, id: question_1, question: { body: '' }, format: :js }.to_not change(question_1, :body)
                end
            end

            context 'change question of other user' do
                it 'but not update question' do
                    expect { patch :update, id: question_2, question: { title: 'new title' }, format: :js }.to_not change(question_2, :title)
                    expect { patch :update, id: question_2, question: { body: 'new body' }, format: :js }.to_not change(question_2, :body)
                end
            end
        end
    end

    describe 'POST #destroy' do
        sign_in_user
        let!(:question_1) { create :question, user: @current_user }
        let!(:question_2) { create :question }

        context 'own question' do
            it 'deletes question' do
                expect { delete :destroy, id: question_1 }.to change(Question, :count).by(-1)
            end

            it 'redirects to questions path' do
                delete :destroy, id: question_1

                expect(response).to redirect_to questions_path
            end
        end

        context 'question of other user' do
            it 'not delete question' do
                expect { delete :destroy, id: question_2 }.to_not change(Question, :count)
            end

            it 'redirects to questions_path' do
                delete :destroy, id: question_2

                expect(response).to redirect_to questions_path
            end
        end
    end
end
