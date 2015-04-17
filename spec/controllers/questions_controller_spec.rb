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
      subject do
        post :create, question: attributes_for(:question).
          merge(attachments_attributes: attributes_for_list(:attachment, 2))
      end

      it 'redirects to show view' do
        expect(subject).to redirect_to assigns(:question)
      end

      it 'saves new question' do
        expect { subject }.to change(current_user.questions, :count).by(1)
      end
      
      it 'saves new attachments' do
        subject
        expect(current_user.questions.last.attachments.count).to eq(2)
      end
      
    end

    context 'with invalid attributes' do
      subject { post :create, question: attributes_for(:invalid_question) }

      it { should render_template :new }

      it "doesn't save invalid question" do
        expect { subject }.to_not change(Question, :count)
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
        subject do
          patch :update, id: question, question: upd_question.attributes.
            merge(attachments_attributes: attributes_for_list(:attachment, 2)), format: :js
        end

        it { should render_template :update }

        it 'updates a question' do
          expect { subject }.to change { [question.reload.title, question.body] }.
            to([upd_question.title, upd_question.body])
        end

        it 'saves new attachments' do
          expect { subject }.to change(question.attachments, :count).by(2)
        end
      end

      context 'with invalid attributes' do
        subject { patch :update, id: question, question: attributes_for(:invalid_question), format: :js }
        
        it { should render_template :update }

        it 'does not update a question' do
          expect { subject }.to_not change { question.reload.attributes }
        end
      end
    end
    
    context "an another user's question" do
      subject { patch :update, id: another_question, question: upd_question.attributes, format: :js }

      it 'does not update that question' do
        expect { subject }.to_not change { another_question.reload.attributes }
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user

    context 'own question' do
      let!(:question) { create(:question, user: current_user) }

      context 'by request with html format' do
        subject { delete :destroy, id: question  }

        it "removes one" do
          expect { subject }.to change(current_user.questions, :count).by(-1)
        end

        it "redirects to index view" do
          subject
          expect(response).to redirect_to questions_path
        end
      end

      context 'by request with js format' do
        subject { delete :destroy, id: question, format: :js }

        it { should render_template :destroy }

        it "removes one" do
          expect { subject }.to change(current_user.questions, :count).by(-1)
        end
      end
    end

    context "another user's question" do
      let!(:question) { create(:question) }

      context 'by request with html format' do
        subject { delete :destroy, id: question }

        it "doesn't remove one" do
          expect { subject }.to_not change(Question, :count)
        end

        it "receives a 'forbidden' status" do
          subject
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'by request with js format' do
        subject { delete :destroy, id: question, format: :js }

        it "doesn't remove one" do
          expect { subject }.to_not change(Question, :count)
        end

        it "receives a 'forbidden' status" do
          subject
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

end
