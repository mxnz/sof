require_relative 'features_helper'

RSpec.feature 'Select best answer', %{
  In order to help readers
  As a question author
  I want to be able to select the best answer
}, type: :feature, js: true do

  given!(:question) { create(:question) }
  given!(:another_question) { create(:question) }

  before do
    3.times { create(:answer, question: question, user: question.user) }
    2.times { create(:answer, question: another_question, user: another_question.user) }
  end

  scenario 'A question author selects the best answer' do
    sign_in question.user
    visit question_path(question)

    expect(first(".answers li")).to_not have_content question.answers[2].body

    find("#answer_#{question.answers[2].id} .answer_best_false a").click
    
    sleep(1)
    
    expect(first(".answers li")).to have_content question.answers[2].body
    expect(first(".answers li")).to have_css("#answer_#{question.answers[2].id} .answer_best_true a")
  end

  scenario "User cannot select the best answer for another user's question" do
    sign_in question.user
    visit question_path(another_question)
    
    expect(page).to_not have_css(".answer_best_false a")
    expect(page).to_not have_css(".answer_best_true a")
  end
end
