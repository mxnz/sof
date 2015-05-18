require 'rails_helper'

RSpec.describe Reputation, type: :model do
  let(:question) { create(:question) }

  describe '.after_answer' do
    context "when not first answer to other's question" do
      let!(:first_answer) { create(:answer, question: question) }
      let!(:not_first_answer) { create(:answer, question: question) }

      context 'is created' do
        it "returns 1" do
          expect(Reputation.after_answer(not_first_answer)).to eq 1
        end
      end

      context 'is destroyed' do
        context 'and when it is not the best' do
          it 'returns -1' do
            not_first_answer.destroy
            expect(Reputation.after_answer(not_first_answer)).to eq -1
          end
        end

        context 'and when it is the best' do
          it 'returns -4' do
            not_first_answer.update(best: true)
            not_first_answer.destroy
            expect(Reputation.after_answer(not_first_answer)).to eq -4
          end
        end
      end
    end


    context "when first answer to other's question" do
      let!(:first_answer) { create(:answer, question: question) }

      context 'is created' do
        it 'returns 2' do
          expect(Reputation.after_answer(first_answer)).to eq  2
        end
      end

      context 'is destroyed' do
        context 'and when it is not the best' do
          it 'returns -2' do
            first_answer.destroy
            expect(Reputation.after_answer(first_answer)).to eq -2
          end
        end

        context 'and when it is the best' do
          it 'returns -5' do
            first_answer.update(best: true)
            first_answer.destroy
            expect(Reputation.after_answer(first_answer)).to eq -5
          end
        end
      end
    end


    context 'when not first answer to own question' do
      let!(:first_answer) { create(:answer, question: question) }
      let!(:not_first_answer) { create(:answer, question: question, user: question.user) }
      
      context 'is created' do
        it 'returns 2' do
          expect(Reputation.after_answer(not_first_answer)).to eq 2
        end
      end
      
      context 'is destroyed' do
        context 'and when it is not the best' do
          it 'returns -2' do
            not_first_answer.destroy
            expect(Reputation.after_answer(not_first_answer)).to eq -2
          end
        end

        context 'and when it is the best' do
          it 'returns -5' do
            not_first_answer.update(best: true)
            not_first_answer.destroy
            expect(Reputation.after_answer(not_first_answer)).to eq -5
          end
        end
      end
    end

    context 'when first answer to own question' do
      let!(:first_answer) { create(:answer, question: question, user: question.user) }

      context 'is created' do
        it 'returns 3' do
          expect(Reputation.after_answer(first_answer)).to eq 3
        end
      end

      context 'is destroyed' do
        context 'and when it is not the best' do
          it 'returns -3' do
            first_answer.destroy
            expect(Reputation.after_answer(first_answer)).to eq -3
          end
        end

        context 'and when it is the best' do
          it 'returns -6' do
            first_answer.update(best: true)
            first_answer.destroy
            expect(Reputation.after_answer(first_answer)).to eq -6
          end
        end
      end
    end
  end


  describe '.after_best_answer' do
    let(:answer) { create(:answer) }

    context 'when answer is selected as best' do
      it 'returns 3' do
        answer.update(best: true)
        expect(Reputation.after_best_answer(answer)).to eq 3
      end
    end

    context 'when answer is unselected as best' do
      it 'returns -3' do
        expect(Reputation.after_best_answer(answer)).to eq -3
      end
    end
  end


  describe '.after_vote' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer) }

    context 'when vote for question' do
      let!(:vote) { create(:vote, votable: question, up: true) }

      context 'is created' do
        it 'returns 2' do
          expect(Reputation.after_vote(vote)).to eq 2
        end
      end
      context 'is destroyed' do
        it 'returns -2' do
          vote.destroy
          expect(Reputation.after_vote(vote)).to eq -2
        end
      end
    end

    context 'when vote against question' do
      let!(:vote) { create(:vote, votable: question, up: false) }

      context 'is created' do
        it 'returns -2' do
          expect(Reputation.after_vote(vote)).to eq -2
        end
      end
      context 'is destroyed' do
        it 'returns 2' do
          vote.destroy
          expect(Reputation.after_vote(vote)).to eq 2
        end
      end
    end

    context 'when vote for answer' do
      let!(:vote) { create(:vote, votable: answer, up: true) }

      context 'is created' do
        it 'returns 1' do
          expect(Reputation.after_vote(vote)).to eq 1
        end
      end
      context 'is destroyed' do
        it 'returns -1' do
          vote.destroy
          expect(Reputation.after_vote(vote)).to eq -1
        end
      end
    end

    context 'when vote against answer' do
      let!(:vote) { create(:vote, votable: answer, up: false) }

      context 'is created' do
        it 'returns -1' do
          expect(Reputation.after_vote(vote)).to eq -1
        end
      end
      context 'is destroyed' do
        it 'returns 1' do
          vote.destroy
          expect(Reputation.after_vote(vote)).to eq 1
        end
      end
    end
  end
end
