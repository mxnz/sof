require_relative 'features_helper'

RSpec.feature 'Voting on an answer', %{
  In order to help the community
  As an authenticated user
  I want to be able to vote on an answer
}, type: :feature, js: true do
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }
  given(:own_answer) { create(:answer, user: user) }

  scenario 'An authenticated user votes for an answer' do
    sign_in user
    visit question_path(answer.question)
    within "#answer_#{answer.id}" do
      within ".rating" do
        expect(page).to have_content "0"
      end
      click_on 'vote up'

      expect(page).to_not have_selector(:link_or_button, 'vote up')
      expect(page).to_not have_selector(:link_or_button, 'vote down')
      expect(page).to have_selector(:link_or_button, 'remove vote')
      within ".rating" do
        expect(page).to have_content("1")
      end
    end
  end

  scenario 'An authenticated user removes his vote for an answer' do
    vote = create(:vote, votable: answer)
    sign_in vote.user
    visit question_path(answer.question)
    within "#answer_#{answer.id}" do
      within '.rating' do
        expect(page).to have_content("1")
      end
      click_on 'remove vote'

      expect(page).to have_selector(:link_or_button, 'vote up')
      expect(page).to have_selector(:link_or_button, 'vote down')
      expect(page).to_not have_selector(:link_or_button, 'remove vote')
      within ".rating" do
        expect(page).to have_content("0")
      end
    end
  end
  
  scenario 'An authenticated user cannot vote for his own answer' do
    sign_in user
    visit question_path(own_answer.question)
    within "#answer_#{own_answer.id}" do
      within ".rating" do
        expect(page).to have_content("0")
      end

      expect(page).to_not have_selector(:link_or_button, 'vote up')
      expect(page).to_not have_selector(:link_or_button, 'vote down')
      expect(page).to_not have_selector(:link_or_button, 'remove vote')
    end
  end

end
