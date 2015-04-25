require_relative 'features_helper'

RSpec.feature 'Add comment to the answer', %{
  In order to help the community
  As an authenticated user
  I want to be able to add comments to the answer
}, type: :feature, js: true do

  given(:answer) { create(:answer) }
  given(:user) { create(:user) }
  before do
    sign_in user
    visit question_path(answer.question)
  end

  scenario 'An authenticated user add comment to the answer' do
    within "#answer_#{answer.id} .comments_wrapper" do
      click_on 'Add Comment'
      fill_in 'Text', with: 'Comment Text'
      click_on 'Publish'

      expect(page).to have_content('Comment Text');
    end
  end

  scenario 'An authenticated user cannot add blank comment to the answer' do
    within "#answer_#{answer.id} .comments_wrapper" do
      click_on 'Add Comment'
      click_on 'Publish'

      expect(page).to have_content("Text can't be blank")
    end
  end
end
