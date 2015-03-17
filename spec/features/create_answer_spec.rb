require 'rails_helper'

RSpec.feature 'Create an answer', %{
  In order to help person, who asked a question,
  As an authenticated user
  I want to have ability to write an answer to a question
}, type: :feature do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { build(:answer) }
  
  scenario 'An authenticated user creates an answer' do
    sign_in user
    visit question_path(question)
    click_on 'Answer'
    fill_in 'Text', with: answer.body
    click_on 'Publish'

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end

  scenario 'An authenticated user tries creating a blank answer' do
    sign_in user
    visit question_path(question)
    click_on 'Answer'
    click_on 'Publish'

    expect(page).to have_content "Text can't be blank"
  end

  scenario 'A non-authenticated user tries creating an answer' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end 
end
