require 'rails_helper'

RSpec.feature 'View questions', %q{
  In order to find required question
  As an user
  I want to be able to view questions list
}, type: :feature do

  given!(:questions) { create_list(:question, 2) }

  scenario 'A user views questions' do
    visit questions_path

    questions.each { |q| expect(page).to have_content q.title }
  end
end
