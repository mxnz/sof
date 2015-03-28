require_relative 'features_helper'

RSpec.feature 'Create an answer', %{
  In order to help a person, who asked a question,
  As an authenticated user
  I want to be able to write an answer to his question
}, type: :feature, js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { build(:answer) }
  
  scenario 'An authenticated user creates an answer' do
    sign_in user
    visit question_path(question)
    click_on 'Answer'

    expect(current_path).to eq question_path(question)

    fill_in 'Text', with: answer.body
    click_on 'Publish'
    
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
    expect(page).to have_selector(:link_or_button, 'Answer')
    expect(page).to_not have_selector(:link_or_button, 'Publish')
    expect(page).to_not have_field 'Text'
  end

  scenario 'An authenticated user cannot create a blank answer' do
    sign_in user
    visit question_path(question)
    click_on 'Answer'
    click_on 'Publish'

    expect(page).to have_content "Text can't be blank"
    expect(current_path).to eq question_path(question)
  end

  scenario 'A non-authenticated user cannot create an answer' do
    visit question_path(question)
    expect(page).to_not have_selector(:link_or_button, 'Answer')
  end 
end
