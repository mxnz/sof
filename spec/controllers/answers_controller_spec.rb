require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe "POST #create" do
    login_user

    context 'with valid data' do
      let(:create_answer) do
        post :create, question_id: question, answer: attributes_for(:answer).
          merge(attachments_attributes: attributes_for_list(:attachment, 2)), format: :json
      end

      it 'should render answers' do
        expect(create_answer).to render_template('answers/_answers')
      end

      it "saves new answer to given question" do
        expect { create_answer }.to change { question.answers.count }.by 1
      end

      it "saves new attachments" do
        create_answer
        expect(question.answers.last.attachments.count).to eq 2
      end
    end

    context 'with invalid data' do
      let(:create_invalid_answer) do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :json
      end

      it 'should respond with json format' do
        create_invalid_answer
        expect(response.header['Content-Type']).to include('application/json')
      end

      it "doesn't save new answer" do
        expect { create_invalid_answer }.to_not change(Answer, :count)
      end
    end
  end
  
  describe "PATCH #update" do
    login_user
    let(:upd_answer) { build(:answer) }

    context 'own answer' do
      let(:answer) { create(:answer, user: current_user) }

      context 'with valid data' do
        let(:update_answer) do
          patch :update, id: answer, answer: upd_answer.attributes.
            merge(attachments_attributes: attributes_for_list(:attachment, 2)), format: :json
        end
        
        it 'should render answer' do
          expect(update_answer).to render_template('answers/_answer')
        end

        it "updates that answer" do
          expect { update_answer }.to change { answer.reload.body }.from(answer.body).to(upd_answer.body)
        end

        it "saves new attachments" do
          expect { update_answer }.to change { answer.attachments.count }.by(2)
        end
      end

      context 'with invalid data' do
        let(:update_invalid_answer) { patch :update, id: answer, answer: attributes_for(:invalid_answer), format: :json }

        it "doesn't update answer" do
          expect { update_invalid_answer }.to_not change { answer.reload.body }
        end
      end
    end

    context "another user's answer" do
      let(:another_answer) { create(:answer) }

      it "doesn't update answer" do
        expect { patch :update, id: another_answer, answer: upd_answer.attributes, format: :json }.
          to_not change { another_answer.reload.body }
      end
    end
    
    context "the best flag for another user's answer"  do
      context "by question's author" do
        let!(:question) { create(:question, user: current_user) }
        let!(:answer) { create(:answer, question: question) }

        it "updates the best flag for that answer" do
          expect { patch :update_best, id: answer, answer: { best: true }, format: :json }.
            to change { answer.reload.best }.from(false).to(true)
        end
      end
      
      context "by user, who is not a question's author" do
        let(:another_answer) { create(:answer) }
        
        it "doesn't update best flag for that answer" do
          expect { patch :update_best, id: another_answer, answer: { best: true }, format: :json }.
            to_not change { another_answer.reload.best }
        end
      end
    end
  end

  describe "DELETE #destroy" do
    login_user

    context 'own answer' do
      let!(:answer) { create(:answer, user: current_user) }
      let(:delete_own_answer) { delete :destroy, id: answer, format: :json }

      it 'should render destroyed answer' do
        expect(delete_own_answer).to render_template('answers/_answer')
      end

      it 'removes one' do
        expect { delete_own_answer }.to change(Answer, :count).by(-1)
      end
    end

    context "an another user's answer" do
      let!(:another_answer) { create(:answer) }
      let(:delete_anothers_answer) { delete :destroy, id: another_answer, format: :json }

      it "doesn't remove one" do
        expect { delete_anothers_answer }.to_not change(Answer, :count)
      end
    end
  end

end
