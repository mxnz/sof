require 'rails_helper'

RSpec.feature 'Remove a question', %{
  In order to not bother a community
  As an author
  I want to be able to remove my question
}, type: :feature do

  given(:question) { create(:question) }
  given(:another_question) { create(:question) }
  
  scenario 'A User removes his/her question' do
    sign_in(question.user)
    visit question_path(question)
    click_on 'Remove Question'

    expect(page).to_not have_content(question.title)
    expect(current_path).to eq questions_path
  end

  scenario "A user cannot remove an another user's question" do
    sign_in(question.user)
    visit question_path(another_question)

    expect(page).to_not have_selector(:link_or_button, 'Remove Question')
  end
end
