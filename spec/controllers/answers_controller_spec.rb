require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe "GET #new" do
    before { get :new, question_id: question }

    it { should render_template :new }

    it "assigns new answer to @answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "associates given question with @answer" do
      expect(assigns(:answer).question_id).to eq question.id
    end
  end

  describe "POST #create" do
    context 'with valid data' do
      before { post :create, question_id: question, answer: attributes_for(:answer) }

      it { should redirect_to question }

      it "saves new answer" do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
      end

      it "associates new answer with given question" do
        expect(assigns(:answer).question).to eq question
      end
    end

    context 'with invalid data' do
      before { post :create, question_id: question, answer: attributes_for(:invalid_answer) }

      it { should render_template :new }

      it "doesn't save new answer" do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end
    end
  end

end
