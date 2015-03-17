require 'rails_helper'

RSpec.feature '', %{
  In order to stop adding questions and answers
  As an authenticated user
  I want to have ability to sign out
}, type: :feature do

  given(:user) { create(:user) }
  
  scenario 'Authenticated user sign out' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_selector(:link_or_button, 'Log in')
    expect(page).to_not have_selector(:link_or_button, 'Log out')
    expect(current_path).to eq root_path
  end
end