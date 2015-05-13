require 'rails_helper'

RSpec.describe 'questions API', type: :request do
  let(:access_token) { create(:access_token) }

  describe 'GET /questions' do
    let!(:questions) { create_list(:question, 3) }

    context 'unauthorized' do
      it_behaves_like 'an unauthorized api request' do
        let(:api_request) { [:get, "/api/v1/questions"] }
      end
    end

    context 'authorized' do
      before { get '/api/v1/questions', access_token: access_token.token, format: :json }

      it 'returns success (200) status' do
        expect(response).to have_http_status(:success)
      end

      it 'should contain all questions' do
        expect(response.body).to be_json_eql(questions.to_json(except: :user_id)).at_path('questions')
      end
    end
  end

  describe 'GET /questions/:question_id' do
    let!(:question) { create(:question) }
    let!(:comments) { create_list(:comment, 3, commentable: question).reverse }
    let!(:attachments) { create_list(:attachment, 2, attachable: question).map { |a| a.file.url }.reverse }

    context 'unauthorized' do
      it_behaves_like 'an unauthorized api request' do
        let(:api_request) { [:get, "/api/v1/questions/#{question.id}"] }
      end
    end

    context 'authorized' do
      context 'with valid question id' do
        before { get "/api/v1/questions/#{question.id}", access_token: access_token.token, format: :json }

        it 'returns success (200) status' do
          expect(response).to have_http_status(:success)
        end

        it 'should contain requested question' do
          question_json = question.as_json.except('user_id').to_json
          expect(response.body).to be_json_eql(question_json).at_path('question').excluding(:comments, :attachments)
        end

        it 'should contain requested question with comments' do
          comments_json = comments.map { |c| c.as_json.except('user_id', 'commentable_id', 'commentable_type') }.to_json
          expect(response.body).to be_json_eql(comments_json).at_path('question/comments')
        end

        it 'should contain requested question with attachments' do
          expect(response.body).to be_json_eql(attachments.to_json).at_path('question/attachments')
        end
      end

      context 'with invalid question id' do
        it_behaves_like 'a not found api request' do
          let(:api_request) { [:get, "/api/v1/questions/abc", {access_token: access_token.token}] }
        end
      end
    end
  end

  describe 'POST /questions' do
    let(:question) { build(:question) }

    context 'unauthorized' do
      it_behaves_like 'an unauthorized api request' do
        let(:api_request) { [:post, '/api/v1/questions', { question: question.attributes }] }
      end
    end

    context 'authorized' do

      context 'with valid attributes' do
        let(:create_question) { post '/api/v1/questions', question: question.attributes, access_token: access_token.token, format: :json }
        let(:authorized_user) { User.find(access_token.resource_owner_id) }

        it 'returns success (200) status' do
          create_question
          expect(response).to have_http_status(:success)
        end

        it 'contains created question with given attributes' do
          create_question
          expect(response.body).to be_json_eql(question.to_json).
            excluding(:id, :user_id, :comments, :attachments, :created_at, :updated_at).at_path('question')
        end

        it 'creates new question for authorized user' do
          expect { create_question }.to change(authorized_user.questions, :count).by(1)
        end

        it 'creates new question with given attributes' do
          create_question
          expect(authorized_user.questions.last.to_json).to be_json_eql(question.to_json).
            excluding(:id, :user_id, :created_at, :updated_at)
        end
      end

      context 'with invalid attributes' do
        let(:invalid_question) { build(:invalid_question) }
        let(:create_invalid_question) { post '/api/v1/questions', question: invalid_question.attributes, access_token: access_token.token, format: :json }

        it 'returns unprocessable entity (422) status' do
          create_invalid_question
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "doesn't create question" do
          expect { create_invalid_question }.to_not change(Question, :count)
        end

        it 'returns errors descriptions' do
          create_invalid_question
          expect(response.body).to have_json_path('errors')
        end
      end
    end
  end
end
