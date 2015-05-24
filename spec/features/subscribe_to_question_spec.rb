require_relative 'features_helper'

RSpec.feature 'Subscribe to question', %{
  In order to get email notifications
  As an authenticated user
  I want to be able to subscribe to question
}, type: :feature, js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'An authenticated user subscribes to question' do
    sign_in user
    visit question_path(question)
    click_on 'Subscribe to the question'

    expect(page).to have_content 'You subscribed to the question'
    expect(page).to_not have_selector(:link_or_button, 'Subscribe to the question')
    expect(page).to have_selector(:link_or_button, 'Unsubscribe from the question')
  end

  scenario 'An unauthenticated user cannot subscribe to question' do  
    visit question_path(question)
    expect(page).to_not have_selector(:link_or_button, 'Subscribe to the question')
  end
end
