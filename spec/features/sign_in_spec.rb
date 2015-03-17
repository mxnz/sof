require 'rails_helper'

RSpec.feature 'User can sign in', %q{
  In order to write questions and answers
  As an user
  I want to have ability to sign in
}, type: :feature do
 
  scenario 'Registered user tries to sign in' do
    sign_in(create(:user))

    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_link 'Log out'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user tries to sign in' do
    sign_in(build(:user))

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq new_user_session_path
  end
end