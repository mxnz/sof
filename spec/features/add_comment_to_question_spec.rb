require_relative 'features_helper'

RSpec.feature 'Add comment to a question', %{
  In order to help community
  As an authenticated user
  I want to be able to add comments to a question
}, type: :feature, js: true do
  
  given(:question) { create(:question) }
  given(:user) { create(:user) }
  before do
    sign_in user
    visit question_path(question)
  end

  scenario 'An authenticated user adds comment to question' do
    within '.question .comments_wrapper' do
      click_on 'Add Comment'
      fill_in 'Text', with: 'Comment Text'
      click_on 'Publish'

      expect(page).to have_content('Comment Text');
    end
  end

  scenario 'An authenticated user cannot add blank comment to question' do
    within '.question .comments_wrapper' do
      click_on 'Add Comment'
      click_on 'Publish'

      expect(page).to have_content("Text can't be blank")
    end
  end
end
