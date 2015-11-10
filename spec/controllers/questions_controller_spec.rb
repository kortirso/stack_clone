RSpec.describe QuestionsController, type: :controller do
    describe 'GET #index' do
        let(:questions) { create_list(:question, 2) }
        before do
            get :index
        end

        it 'collect an array of all questions' do
            expect(assigns(:questions)).to match_array(questions)
        end

        it 'renders index view' do
            expect(response).to render_template :index
        end
    end

    describe 'GET #show' do
        let(:question) { create :question }
        before do
            get :show, id: question
        end

        it 'assigns the requested question to @question' do
            expect(assigns(:question)).to eq question
        end

        it 'renders show view' do
            expect(response).to render_template :show
        end
    end

    describe 'GET #new' do
        before do
            get :new
        end

        it 'assigns a new question to @question' do
            expect(assigns(:question)).to be_a_new(Question)
        end

        it 'renders new view' do
            expect(response).to render_template :new
        end
    end
end
