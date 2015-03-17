require 'rails_helper'

RSpec.feature 'Guest sign up', %{
  In order to become an user
  As a guest
  I want ot have ability to sign up
}, type: :feature do

  given(:user) { build(:user) }
  
  scenario 'Guest sign up' do
    visit root_path
    click_on 'Sign up'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(page).to_not have_selector(:link_or_button, 'Sign up')
    expect(current_path).to eq root_path
  end

  scenario 'Guest tries to sign up with invalid credentials' do
    visit root_path
    click_on 'Sign up'
    click_on 'Sign up'

    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
    expect(current_path).to eq user_registration_path
  end
end