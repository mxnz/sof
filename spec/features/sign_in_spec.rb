require 'rails_helper'

RSpec.feature 'User can sign in', %q{
  In order to write questions and answers
  As an user
  I want to be able to sign in
}, type: :feature do
 
  scenario 'A registered user sign in' do
    sign_in(create(:user))

    expect(page).to have_content 'Signed in successfully'
    expect(page).to_not have_selector(:link_or_button, 'Log in')
    expect(page).to have_selector(:link_or_button, 'Log out')
    expect(current_path).to eq root_path
  end

  scenario 'A non-registered user cannot sign in' do
    sign_in(build(:user))

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq new_user_session_path
  end
end
