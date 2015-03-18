require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe "GET #new" do
    login_user

    before { get :new, question_id: question }

    it { should render_template :new }

    it "assigns new answer to @answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe "POST #create" do
    login_user

    context 'with valid data' do
      before { post :create, question_id: question, answer: attributes_for(:answer) }

      it { should redirect_to question }

      it "saves new answer to given question" do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
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

  describe "DELETE #destroy" do
    login_user

    context 'own answer' do
      let!(:answer) { create(:answer, user: subject.current_user) }

      it do
        delete :destroy, id: answer
        should redirect_to answer.question
      end

      it 'removes one' do
        expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
      end
    end

    context "an another user's answer" do
      let!(:another_answer) { create(:answer) }

      it do
        delete :destroy, id: another_answer
        should redirect_to another_answer.question
      end

      it "doesn't remove one" do
        expect { delete :destroy, id: another_answer }.to_not change(Answer, :count)
      end
    end
  end

end
