describe 'Answers API' do
    let!(:question) { create :question }

    describe 'GET /index' do
        context 'unauthorized' do
            it 'returns 401 status if there is no access_token' do
                get "/api/v1/questions/#{question.id}/answers", format: :json

                expect(response.status).to eq 401
            end

            it 'returns 401 status if access_token is invalid' do
                get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '123456'

                expect(response.status).to eq 401
            end
        end

        context 'authorized' do
            let(:access_token) { create :access_token }
            let!(:answers) { create_list(:answer, 2, question: question) }
            let(:answer) { answers.last }

            before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

            it 'returns 200 status code' do
                expect(response).to be_success
            end

            it 'returns list of answers' do
                expect(response.body).to have_json_size(2).at_path("answers")
            end

            %w(id body created_at updated_at question_id user_id best).each do |attr|
                it "answer object contains #{attr}" do
                    expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
                end
            end
        end
    end

    describe 'GET /show' do
        let!(:answer) { create :answer, question: question }
        let!(:comment) { create :comment, commentable: answer }
        let!(:attachment) { create :attachment, attachable: answer }

        context 'unauthorized' do
            it 'returns 401 status if there is no access_token' do
                get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json

                expect(response.status).to eq 401
            end

            it 'returns 401 status if access_token is invalid' do
                get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: '123456'

                expect(response.status).to eq 401
            end
        end

        context 'authorized' do
            let(:access_token) { create :access_token }

            before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token }

            it 'returns 200 status code' do
                expect(response).to be_success
            end

            it 'returns one answer' do
                expect(response.body).to have_json_size(1)
            end

            %w(id body created_at updated_at question_id user_id best).each do |attr|
                it "answer object contains #{attr}" do
                    expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
                end
            end

            context 'comments' do
                it 'included in answer object' do
                    expect(response.body).to have_json_size(1).at_path("answer/comments")
                end

                %w(id body created_at updated_at user_id).each do |attr|
                    it "contains #{attr}" do
                        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
                    end
                end
            end

            context 'attachments' do
                it 'included in answer object' do
                    expect(response.body).to have_json_size(1).at_path("answer/attachments")
                end

                %w(id file created_at updated_at).each do |attr|
                    it "contains #{attr}" do
                        expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
                    end
                end
            end
        end
    end

    describe 'POST /create' do
        context 'unauthorized' do
            it 'returns 401 status if there is no access_token' do
                post "/api/v1/questions/#{question.id}/answers", format: :json

                expect(response.status).to eq 401
            end

            it 'returns 401 status if access_token is invalid' do
                post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '123456'

                expect(response.status).to eq 401
            end
        end

        context 'authorized' do
            let(:access_token) { create :access_token }
            let(:user) { User.find(access_token.resource_owner_id) }

            context 'with valid attributes' do
                it 'returns 200 status code' do
                    post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token

                    expect(response).to be_success
                end

                it 'saves the new answer in the DB' do
                    expect { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token }.to change(question.answers, :count).by(1)
                end

                it 'belongs to current user' do
                    expect { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token }.to change(user.answers, :count).by(1)
                end
            end

            context 'with invalid attributes' do
                it 'doesnt returns 200 status code' do
                    post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token

                    expect(response).to_not be_success
                end

                it 'does not save the new answer in the DB' do
                    expect { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }.to_not change(Answer, :count)
                end
            end
        end
    end
end