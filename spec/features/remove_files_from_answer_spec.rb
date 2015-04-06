require_relative 'features_helper'

RSpec.feature 'Remove files from an answer', %{
  In order to fix an error
  As an answer author
  I want to be able to remove files from my answer
}, type: :feature, js: true do
  
  given!(:answer) { create(:answer) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  before { sign_in answer.user }

  scenario "A user removes a file from his own answer" do 
    visit question_path(answer.question)
    click_on 'Edit'
    click_on 'Remove file'
    click_on 'Publish'

    expect(page).to_not have_content(attachment.file.identifier)
  end
end
