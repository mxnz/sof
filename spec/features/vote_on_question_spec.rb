require_relative 'features_helper'

RSpec.feature 'Voting for a questions', %{
  In order to attract attention to a question
  As an authenticated user
  I want to be able to vote for a question
}, type: :feature, js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:own_question) { create(:question, user: user) }

  scenario 'An authenticated user votes for a question' do
    sign_in user
    visit question_path(question)
    within ".question" do
      within ".rating" do
        expect(page).to have_content("0")
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

  scenario 'An authenticated user votes against a question' do
    sign_in user
    visit question_path(question)
    within '.question' do
      within '.rating' do
        expect(page).to have_content("0")
      end
      click_on 'vote down'

      expect(page).to_not have_selector(:link_or_button, 'vote up')
      expect(page).to_not have_selector(:link_or_button, 'vote down')
      expect(page).to have_selector(:link_or_button, 'remove vote')
      within ".rating" do
        expect(page).to have_content("-1")
      end
    end
  end

  scenario 'An authenticated user removes his vote for a question' do
    vote = create(:vote, votable: question)
    sign_in vote.user
    visit question_path(question)
    within '.question' do
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
  
  scenario 'An authenticated user cannot vote for his own question' do
    sign_in user
    visit question_path(own_question)
    within ".question" do
      within ".rating" do
        expect(page).to have_content("0")
      end

      expect(page).to_not have_selector(:link_or_button, 'vote up')
      expect(page).to_not have_selector(:link_or_button, 'vote down')
      expect(page).to_not have_selector(:link_or_button, 'remove vote')
    end
  end
end
