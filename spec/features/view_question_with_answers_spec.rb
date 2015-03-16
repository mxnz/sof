require 'rails_helper'

RSpec.feature 'View question with its answers', %{
  In order to find out answer
  As an user
  I want to have ability to view question with its answers
}, type: :feature, focus: true do

  scenario 'User views question with its answers' do
    question = create(:question)
    answers = create_list(:answer, 2, question: question)

    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body
  end
end
