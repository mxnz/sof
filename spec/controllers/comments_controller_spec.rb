require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let(:comment) { build(:comment, commentable: question) }

  describe "POST #create" do
    login_user

    context 'with valid data' do
      let(:create_comment) { post :create, question_id: question.id, comment: comment.attributes, format: :js }
      
      it 'should render :create' do
        create_comment
        expect(response).to render_template :create
      end

      it 'saves a new comment' do
        expect { create_comment }.to change(question.comments, :count).by(1)
      end
    end

    context 'with invalid data' do
      let(:create_invalid_comment) { post :create, question_id: question.id, comment: attributes_for(:invalid_comment), format: :js }

      it "doesn't save a new comment" do
        expect { create_invalid_comment }.to_not change(Comment, :count)
      end
    end
  end
end
