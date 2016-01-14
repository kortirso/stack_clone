RSpec.describe ApplicationController, type: :controller do
    describe 'GET #search' do
        it 'renders search template' do
            get :search, search: { query: 'job', options: 1}

            expect(response).to render_template 'layouts/search'
        end
    end
end