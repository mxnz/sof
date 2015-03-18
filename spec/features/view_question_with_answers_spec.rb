require 'rails_helper'

RSpec.feature 'View question with its answers', %{
  In order to find out the answer
  As an user
  I want to be able to view a question with its answers
}, type: :feature do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'A user views a question with its answers' do
    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body
  end
end
