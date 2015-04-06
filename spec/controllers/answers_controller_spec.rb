require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe "POST #create" do
    login_user

    context 'with valid data' do
      before { post :create, question_id: question, answer: attributes_for(:answer), format: :js }

      it { should render_template :create }

      it "saves new answer to given question" do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.
          to change(question.answers, :count).by(1)
      end

      it "saves new attachments" do
        post :create, question_id: question, answer: attributes_for(:answer).
          merge(attachments_attributes: attributes_for_list(:attachment, 2)), format: :js
        expect(question.answers.order(:created_at).last.attachments.count).to eq 2
      end
    end

    context 'with invalid data' do
      before { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }

      it { should render_template :create }

      it "doesn't save new answer" do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end
    end
  end
  
  describe "PATCH #update" do
    login_user
    let(:upd_answer) { build(:answer) }

    context 'own answer' do
      let(:answer) { create(:answer, user: current_user) }

      context 'with valid data' do
        before { patch :update, id: answer, answer: upd_answer.attributes, format: :js }
        
        it { should render_template :update }
        
        it "updates that answer" do
          answer.reload
          expect(answer.body).to eq upd_answer.body
        end

        it "saves new attachments" do
          patch :update, id: answer, answer: upd_answer.attributes.
            merge(attachments_attributes: attributes_for_list(:attachment, 2)), format: :js
          expect(answer.attachments.count).to eq 2
        end
      end

      context 'with invalid data' do
        before { patch :update, id: answer, answer: attributes_for(:invalid_answer), format: :js }

        it "doesn't update answer" do
          new_answer = Answer.find(answer.id)
          expect(new_answer.body).to eq answer.body
        end
      end
    end

    context "another user's answer" do
      let(:another_answer) { create(:answer) }

      before { patch :update, id: another_answer, answer: upd_answer.attributes, format: :js }

      it "doesn't update answer" do
        another_answer.reload

        expect(another_answer.body).to_not eq upd_answer.body
      end
    end
    
    context "the best flag for another user's answer"  do
      context "by question's author" do
        let!(:question) { create(:question, user: current_user) }
        let!(:answer) { create(:answer, question: question) }

        it "updates the best flag for that answer" do
          expect { patch :update_best, id: answer, answer: { best: true }, format: :js }.to change { answer.reload.best }.from(false).to(true)
        end
      end
      
      context "by user, who is not a question's author" do
        let(:another_answer) { create(:answer) }
        
        it "doesn't update best flag for that answer" do
          expect { patch :update_best, id: another_answer, answer: { best: true }, format: :js }.to_not change { another_answer.reload.best }
        end
      end
    end
  end

  describe "DELETE #destroy" do
    login_user

    context 'own answer' do
      let!(:answer) { create(:answer, user: current_user) }

      it do
        delete :destroy, id: answer, format: :js
        should render_template :destroy 
      end

      it 'removes one' do
        expect { delete :destroy, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context "an another user's answer" do
      let!(:another_answer) { create(:answer) }

      it do
        delete :destroy, id: another_answer, format: :js
        should render_template :destroy 
      end

      it "doesn't remove one" do
        expect { delete :destroy, id: another_answer, format: :js }.to_not change(Answer, :count)
      end
    end
  end

end
