require_relative 'features_helper'

RSpec.feature 'Search', %{
  In order to find required question
  An a user
  I want to be able to perform full-text search
}, type: :feature, js: true do

  given!(:question1) { create(:question, body: 'aaa') }
  given!(:question2) { create(:question, body: 'bbb') }
  given!(:question3) { create(:question, body: 'ccc') }
  given!(:question4) { create(:question, body: 'ddd') }
  given!(:question5) { create(:question, body: 'eee') }

  given!(:answer1) { create(:answer, body: 'fff', question: question2) }
  given!(:q_comment) { create(:comment, body: 'kkk', commentable: question3) }
  given!(:a_comment) { create(:comment, body: 'ggg', commentable: answer1) }
  given!(:answer2) { create(:answer, body: question1, question: question4) }

  scenario 'search everywhere' do
    ThinkingSphinx::Test.run do
      visit root_path
      fill_in 'search_value', with: question1.body
      select 'everywhere', from: 'search_domain'
      click_on 'Search'

      expect(page).to have_link(question4.title)
      expect(page).to have_link(question1.title)
      
      expect(page).to_not have_link(question2.title)
      expect(page).to_not have_link(question3.title)
      expect(page).to_not have_link(question5.title)
    end
  end

  scenario 'search in questions' do
    ThinkingSphinx::Test.run do
      visit root_path
      fill_in 'search_value', with: question1.body
      select 'in questions', from: 'search_domain'
      click_on 'Search'

      expect(page).to have_link(question1.title)

      expect(page).to_not have_link(question2.title)
      expect(page).to_not have_link(question3.title)
      expect(page).to_not have_link(question4.title)
      expect(page).to_not have_link(question5.title)
    end
  end

  scenario 'search in answers' do
    ThinkingSphinx::Test.run do
      visit root_path
      fill_in 'search_value', with: answer1.body
      select 'in answers', from: 'search_domain'
      click_on 'Search'

      expect(page).to have_link(question2.title)

      expect(page).to_not have_link(question1.title)
      expect(page).to_not have_link(question3.title)
      expect(page).to_not have_link(question4.title)
      expect(page).to_not have_link(question5.title)
    end
  end

  scenario "search in questions' comments" do
    ThinkingSphinx::Test.run do
      visit root_path
      fill_in 'search_value', with: q_comment.body
      select "in questions' comments", from: 'search_domain'
      click_on 'Search'

      expect(page).to have_link(question3.title)

      expect(page).to_not have_link(question1.title)
      expect(page).to_not have_link(question2.title)
      expect(page).to_not have_link(question4.title)
      expect(page).to_not have_link(question5.title)
    end
  end

  scenario "search in answers' comments" do
    ThinkingSphinx::Test.run do
      visit root_path
      fill_in 'search_value', with: a_comment.body
      select "in answers' comments", from: 'search_domain'
      click_on 'Search'

      expect(page).to have_link(question2.title)

      expect(page).to_not have_link(question1.title)
      expect(page).to_not have_link(question3.title)
      expect(page).to_not have_link(question4.title)
      expect(page).to_not have_link(question5.title)
    end
  end
end
