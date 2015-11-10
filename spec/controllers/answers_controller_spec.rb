RSpec.describe AnswersController, type: :controller do
	let(:question) { create :question }

	describe 'GET #new' do
		before { get :new }

        it 'assigns a new question to @question' do
            expect(assigns(:answer)).to be_a_new(Answer)
        end

        it 'renders new view' do
            expect(response).to render_template :new
        end
	end

	describe 'POST #create' do
		let(:answer) { create :answer, question: question }

		context 'with valid attributes' do
			it 'saves the new answer in the DB' do
				expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(Question.answers, :count).by(1)
			end

			it 'redirects to question show action' do
            		post :create, answer: attributes_for(:answer), question_id: question

            		expect(response).to redirect_to answer.question
			end
		end

		context 'with invalid attributes' do
			it 'does not save the new answer in the DB' do
				expect { post :create, answer: attributes_for(:invalid_answer), question_id: question }.to_not change(Question.answers, :count)
			end

			it 're-render new view' do
				post :create, answer: attributes_for(:invalid_answer), question_id: question

				expect(response).to render_template :new
			end
		end
	end
end
