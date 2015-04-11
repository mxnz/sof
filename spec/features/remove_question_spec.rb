require_relative 'features_helper'

RSpec.feature 'Remove a question', %{
  In order to not bother a community
  As an author
  I want to be able to remove my question
}, type: :feature, js: true do

  given!(:question) { create(:question) }
  given!(:another_question) { create(:question) }

  before { sign_in(question.user) }
  
  scenario "A User removes his own question from question page" do
    visit question_path(question)
    click_on 'Edit'
    click_on 'Delete'

    expect(page).to_not have_content(question.title)
    expect(current_path).to eq questions_path
  end

  scenario "A user cannot remove an another user's question from question page" do
    visit question_path(another_question)

    expect(page).to_not have_selector(:link_or_button, 'Edit')
  end
  
  scenario "A user removes his own question from main page" do
    find("#question_#{question.id}").click_on "Delete"

    expect(page).to_not have_content(question.title)
  end

  scenario "A user cannot remove an another user's question from main page" do
    within "#question_#{another_question.id}" do
      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end
  end
end
