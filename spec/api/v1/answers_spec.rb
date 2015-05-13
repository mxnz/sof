require 'rails_helper'

RSpec.describe 'answers API', type: :request do
  let(:access_token) { create(:access_token) }

  describe 'GET /questions/:question_id/answers' do
    let(:question) { create(:question) }
    let!(:question_answers) { create_list(:answer, 3, question: question).reverse }
    let!(:other_answers) { create_list(:answer, 2) }

    context 'unauthorized' do
      it_behaves_like 'an unauthorized api request' do
        let(:api_request) { [:get, "/api/v1/questions/#{question.id}/answers"] }
      end
    end

    context 'authorized' do
      context 'with valid question id' do
        before { get "/api/v1/questions/#{question.id}/answers", access_token: access_token.token, format: :json }

        it "returns success (200) status" do
          expect(response).to have_http_status(:success)
        end

        it "contains answers array for given question" do
          expect(response.body).to be_json_eql(question_answers.to_json(except: :user_id)).at_path('answers')
        end
      end

      context 'with invalid question id' do
        it_behaves_like 'a not found api request' do
          let(:api_request) { [:get, "/api/v1/questions/abc/answers", { access_token: access_token.token }] }
        end
      end
    end
  end

  describe "GET /answers/:id" do
    let!(:answer) { create(:answer) }
    let!(:comments) { create_list(:comment, 3, commentable: answer).reverse }
    let!(:attachments) { create_list(:attachment, 2, attachable: answer).map { |a| a.file.url }.reverse }

    context 'unauthorized' do
      it_behaves_like('an unauthorized api request') do
        let(:api_request) { [:get, "/api/v1/answers/#{answer.id}"] }
      end
    end

    context 'authorized' do
      context 'with valid answer id' do
        before { get "/api/v1/answers/#{answer.id}", access_token: access_token.token, format: :json }

        it 'returns success (200) status' do
          expect(response).to have_http_status(:success)
        end

        it 'contains answer attributes' do
          answer_json = answer.as_json().except('user_id').to_json
          expect(response.body).to be_json_eql(answer_json).at_path('answer').excluding(:comments, :attachments)
        end

        it 'contains answer comments' do
          comments_json = comments.map { |c| c.as_json.except('user_id', 'commentable_id', 'commentable_type') }.to_json
          expect(response.body).to be_json_eql(comments_json).at_path('answer/comments')
        end

        it 'contains answer attachments' do
          expect(response.body).to be_json_eql(attachments.to_json).at_path('answer/attachments')
        end
      end

      context 'with invalid answer id' do
        it_behaves_like 'a not found api request' do
          let(:api_request) { [:get, "/api/v1/answers/abc", { access_token: access_token.token }] }
        end
      end
    end
  end

  describe 'POST /questions/:question_id/answers' do
    let(:question) { create(:question) }
    let!(:answer) { build(:answer, question: question) }

    context 'unauthorized' do
      it_behaves_like 'an unauthorized api request' do
        let(:api_request) { [:post, "/api/v1/questions/#{question.id}/answers", { answer: answer.attributes }] }
      end
    end

    context 'authorized' do
      context 'with valid quesiton id' do
        context 'and valid answer attributes' do
          let(:create_answer) do
            post "/api/v1/questions/#{question.id}/answers", answer: answer.attributes, access_token: access_token.token, format: :json
          end

          it 'returns success (200) status' do
            create_answer
            expect(response).to have_http_status(:success)
          end

          it 'contains given answer attributes' do
            create_answer
            expect(response.body).to be_json_eql(answer.to_json).at_path('answer').
              excluding(:id, :attachments, :comments, :user_id, :created_at, :updated_at)
          end

          it 'creates new answer for authorized user' do
            authorized_user = User.find(access_token.resource_owner_id)
            expect { create_answer }.to change(authorized_user.answers, :count).by(1)
          end

          it 'creates new answer for given question' do
            expect { create_answer }.to change(question.answers, :count).by(1)
          end
        end

        context 'with invalid answer attributes' do
          let(:create_invalid_answer) do
            post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:invalid_answer), access_token: access_token.token, format: :json
          end

          it 'returns unprocessable entity (422) status' do
            create_invalid_answer
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'contains errors descriptions' do
            create_invalid_answer
            expect(response.body).to have_json_path('errors')
          end

          it "doesn't create new answer" do
            expect { create_invalid_answer }.to_not change(Answer, :count)
          end
        end
      end

      context 'with invalid question id' do
        it_behaves_like 'a not found api request' do
          let(:api_request) { [:post, "/api/v1/questions/abc/answers", { answer: answer.attributes, access_token: access_token.token }] }
        end
      end
    end
  end

end
