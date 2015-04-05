require_relative 'features_helper'

RSpec.feature 'Remove files from a question', %{
  In order to fix an error
  As a question author
  I want to be able to remove files from my question
}, type: :feature, js: true do

  given!(:question) { create(:question) }
  given!(:attachment) { create(:attachment, attachable: question) }

  before { sign_in question.user }

  scenario "A user removes a file from his own question" do
    visit question_path(question)
    click_on 'Edit Question'
    click_on 'Remove file'
    click_on 'Publish'

    expect(page).to_not have_content(attachment.file.identifier)
  end
end
