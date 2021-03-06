require_relative 'features_helper.rb'

RSpec.feature 'Unsubscribe from question', %{
  In order to not receive email notifications
  As an authenticated user
  I want to be able to unsubscribe from subscribed question
}, type: :feature, js: true do

  given(:subscription) { create(:subscription) }

  scenario '' do
    sign_in subscription.user
    visit question_path(subscription.question)
    click_on 'Unsubscribe from the question'

    expect(page).to_not have_selector(:link_or_button, 'Unsubscribe from the question')
    expect(page).to_not have_content('You subscribed to the question')
    expect(page).to have_selector(:link_or_button, 'Subscribe to the question')
  end

  scenario 'An unauthenticated user cannot unsubscribe from question' do
    visit question_path(subscription.question)
    expect(page).to_not have_selector(:link_or_button, 'Unsubscribe from the question')
  end

end
