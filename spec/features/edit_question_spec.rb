require_relative 'features_helper'

RSpec.feature 'Edit question', %q{
  In order to change my question
  As an author
  I want to be able to edit my question
}, type: :feature, js: true do

  given(:question) { create(:question) }
  given(:another_question) { create(:question) }

  scenario 'An authenticated user can edit his own question' do
    sign_in question.user 
    visit question_path(question)
    click_on 'Edit Question'

    expect(page).to_not have_selector(:link_or_button, 'Edit Question')

    fill_in 'Title', with: 'New Title'
    fill_in 'Text', with: 'New Text'
    click_on 'Publish'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'New Title'
    expect(page).to have_content 'New Text'
    expect(page).to_not have_field 'Title'
    expect(page).to_not have_field 'Text'
    expect(page).to_not have_selector(:link_or_button, 'Publish')
  end
  
  scenario 'An authenticated user cannot save his own edited question with invalid data' do
    sign_in question.user
    visit question_path(question)
    click_on 'Edit Question'
    fill_in 'Title', with: ''
    fill_in 'Text', with: ''
    click_on 'Publish'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Title can't be blank"
  end

  scenario "An authenticated user cannot edit an another user's question" do
    sign_in question.user
    visit question_path(another_question)

    expect(page).to_not have_selector(:link_or_button, 'Edit Question')
  end

  scenario 'A non-authenticated user cannot edit any question' do
    visit question_path(question)
    
    expect(page).to_not have_selector(:link_or_button, 'Edit Answer')
  end
end
