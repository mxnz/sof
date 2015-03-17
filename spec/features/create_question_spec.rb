require 'rails_helper'

RSpec.feature "Create a question", %{
  In order to get an answer
  As an user
  I want to have ability to ask a question
}, type: :feature do

  given(:user) { create(:user) }
  given(:question) { build(:question) }

  scenario "An authenticated user creates a question" do
    sign_in user 
    click_on 'Ask Question'
    fill_in 'Title', with: question.title
    fill_in 'Text', with: question.body
    click_on 'Publish'

    expect(page).to have_content 'Your question is published successfully.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'An authenticated user tries creating a question without title or text' do
    sign_in user
    click_on 'Ask Question'
    click_on 'Publish'

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Text can't be blank"
  end

  scenario 'A Non-authenticated user tries creating a question' do
    visit root_path
    click_on 'Ask Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end

end
