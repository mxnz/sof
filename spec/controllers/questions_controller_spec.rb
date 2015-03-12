require 'rails_helper'

RSpec.describe QuestionsController, type: :controller, focus: true do

  let(:question) { create(:question) }

  describe "GET #index" do
    before { get :index }

    it 'renders index view' do
      expect(response).to render_template :index
    end

    it 'populates an array of all questions' do
      questions = create_list(:question, 2)
      expect(assigns(:questions)).to match_array(questions)
    end
  end

  describe "GET #show" do
    before { get :show, id: question }

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
  end

  describe "GET #new" do
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'saves new question' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
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

end
