require_relative 'features_helper'

RSpec.feature 'Remove comment to question', %{
  In order to fix error
  As an authenticated user
  I want to be able to remove my comment to a question
}, type: :feature, js: true do

  given!(:question) { create(:question) }
  given!(:comment) { create(:comment, commentable: question) }
  given!(:another_comment) { create(:comment, commentable: question) }
  before do
    sign_in comment.user
    visit question_path(question)
  end

  scenario 'An authenticated user removes his own comment to the question' do
    within ".question .comments_wrapper #comment_#{comment.id}" do
      click_on 'Remove Comment'
    end
    expect(page).to_not have_content(comment.body);
  end

  scenario "An authenticated user cannot remove other's comment to the question" do
    within ".question .comments_wrapper #comment_#{another_comment.id}" do
      expect(page).to_not have_selector(:link_or_button, 'Remove Comment')
    end
  end
end
