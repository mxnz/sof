require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:question) { create(:question) }

  describe "GET #index" do
    before { get :index }

    it { should render_template :index }

    it 'populates an array of all questions' do
      questions = create_list(:question, 2)
      expect(assigns(:questions)).to match_array(questions)
    end
  end

  describe "GET #show" do
    before { get :show, id: question }

    it { should render_template :show }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
  end

  describe "GET #new" do
    login_user

    before { get :new }

    it { should render_template :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "assigns new question's user to current user" do
      expect(assigns(:question).user).to eq current_user
    end
  end

  describe 'POST #create' do
    login_user

    context 'with valid attributes' do
      let(:create_question) do
        post :create, question: attributes_for(:question).
          merge(attachments_attributes: attributes_for_list(:attachment, 2))
      end

      it 'redirects to show view' do
        expect(create_question).to redirect_to assigns(:question)
      end

      it 'saves new question' do
        expect { create_question }.to change(current_user.questions, :count).by(1)
      end
      
      it 'saves new attachments' do
        create_question
        expect(current_user.questions.last.attachments.count).to eq(2)
      end
      
    end

    context 'with invalid attributes' do
      let(:create_invalid_question) { post :create, question: attributes_for(:invalid_question) }

      it "should render 'new'" do
        create_invalid_question
        should render_template :new
      end

      it "doesn't save invalid question" do
        expect { create_invalid_question }.to_not change(Question, :count)
      end
    end
  end
  
  describe 'PATCH #update' do
    login_user
    let(:question) { create(:question, user: current_user) }
    let(:another_question) { create(:question) }
    let(:upd_question) { build(:question) }
    
    context 'own question' do
      context 'with valid attributes' do
        let(:update_question) do
          patch :update, id: question, question: upd_question.attributes.
            merge(attachments_attributes: attributes_for_list(:attachment, 2)), format: :js
        end

        it 'should render :update' do
          update_question
          expect(response).to render_template :update
        end

        it 'updates a question' do
          expect { update_question }.to change { [question.reload.title, question.body] }.
            to([upd_question.title, upd_question.body])
        end

        it 'saves new attachments' do
          expect { update_question }.to change(question.attachments, :count).by(2)
        end
      end

      context 'with invalid attributes' do
        let(:update_invalid_question) do
          patch :update, id: question, question: attributes_for(:invalid_question), format: :js
        end
        
        it do
          update_invalid_question
          expect(response).to render_template :update
        end

        it 'does not update a question' do
          expect { update_invalid_question }.to_not change { question.reload.attributes }
        end
      end
    end
    
    context "an another user's question" do
      let(:update_anothers_question) do
        patch :update, id: another_question, question: upd_question.attributes, format: :js
      end

      it 'does not update that question' do
        expect { update_anothers_question }.to_not change { another_question.reload.attributes }
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user

    context 'own question' do
      let!(:question) { create(:question, user: current_user) }

      context 'by request with html format' do
        let(:html_delete_question) { delete :destroy, id: question  }

        it "removes one" do
          expect { html_delete_question }.to change { current_user.questions.count }.by(-1)
        end

        it "redirects to index view" do
          expect(html_delete_question).to redirect_to questions_path
        end
      end

      context 'by request with js format' do
        let(:js_delete_question) { delete :destroy, id: question, format: :js }

        it 'should render :destroy' do
          js_delete_question
          expect(response).to render_template :destroy
        end

        it "removes one" do
          expect { js_delete_question }.to change { current_user.questions.count }.by(-1)
        end
      end
    end

    context "another user's question" do
      let!(:question) { create(:question) }

      context 'by request with html format' do
        let(:delete_anothers_question) { delete :destroy, id: question }

        it "doesn't remove one" do
          expect { delete_anothers_question }.to_not change(Question, :count)
        end

        it "receives a 'forbidden' status" do
          delete_anothers_question
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'by request with js format' do
        let(:js_delete_anothers_question) { delete :destroy, id: question, format: :js }

        it "doesn't remove one" do
          expect { js_delete_anothers_question }.to_not change(Question, :count)
        end

        it "receives a 'forbidden' status" do
          js_delete_anothers_question
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

end
