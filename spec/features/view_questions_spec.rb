require 'rails_helper'

RSpec.feature 'View questions', %q{
  In order to find required question
  As an user
  I want to have ability to view questions list
}, type: :feature do

  scenario 'User views questions' do
    questions = create_list(:question, 2)
    visit questions_path

    questions.each do |q|
      expect(page).to have_content q.title
      expect(page).to have_content q.body
    end
  end
end