require 'rails_helper'

RSpec.feature "Create a question", %{
  In order to get an answer
  As an user
  I want to have ability to ask a question
}, type: :feature do

  given(:question) { build(:question) }

  scenario "User creates a question" do
    visit questions_path
    click_on 'Ask Question'
    fill_in 'Title', with: question.title
    fill_in 'Text', with: question.body
    click_on 'Publish'

    expect(page).to have_content 'Your question is published successfully.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'User tries creating a question without title or text' do
    visit questions_path
    click_on 'Ask Question'
    click_on 'Publish'

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Text can't be blank"
  end

end
