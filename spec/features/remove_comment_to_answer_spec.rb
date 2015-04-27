require_relative 'features_helper'

RSpec.feature 'Remove comment to answer', %{
  In order to fix error
  As an authenticated user
  I want to be able to remove my comment to an answer
}, type: :feature, js: true do

  given!(:answer) { create(:answer) }
  given!(:comment) { create(:comment, commentable: answer) }
  given!(:another_comment) { create(:comment, commentable: answer) }
  before do
    sign_in comment.user
    visit question_path(answer.question)
  end

  scenario 'An authenticated user removes his own comment to an answer' do
    within "#answer_#{answer.id} .comments_wrapper #comment_#{comment.id}" do
      click_on 'Remove Comment'
    end
    expect(page).to_not have_content(comment.body)
  end

  scenario "An authenticated user cannot remove others' comment to an answer" do
    within "#answer_#{answer.id} .comments_wrapper #comment_#{another_comment.id}" do
      expect(page).to_not have_selector(:link_or_button, 'Remove Comment')
    end
  end
end
