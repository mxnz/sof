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
      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to assigns(:question)
      end

      it 'saves new question' do
        expect { post :create, question: attributes_for(:question) }.to change(current_user.questions, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end

      it "doesn't save invalid question" do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user

    context 'own question' do
      let!(:question) { create(:question, user: current_user) }

      it "removes one" do
        expect { delete :destroy, id: question }.to change(current_user.questions, :count).by(-1)
      end

      it "redirects to index view" do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context "another user's question" do
      let!(:question) { create(:question) }

      it "doesn't remove one" do
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it "redirects to index view" do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end
  end

end
