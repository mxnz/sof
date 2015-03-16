require 'rails_helper'

RSpec.feature 'Create an answer', %{
  In order to help person, who asked a question,
  As an user
  I want to have ability to write an answer to a question
}, type: :feature do

  given(:question) { create(:question) }
  given(:answer) { build(:answer) }
  
  scenario 'User creates an answer' do
    visit question_path(question)
    click_on 'Answer'
    fill_in 'Text', with: answer.body
    click_on 'Publish'

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end

  scenario 'User tries creating blank answer' do
    visit question_path(question)
    click_on 'Answer'
    click_on 'Publish'

    expect(page).to have_content "Text can't be blank"
  end
end
