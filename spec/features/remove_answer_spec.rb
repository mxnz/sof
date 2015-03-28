require_relative 'features_helper'

RSpec.feature '', %{
  In order to fix an error
  As an authenticated author
  I want to be able to remove my answer
}, type: :feature, js: true do

  given(:answer) { create(:answer) }
  given(:another_answer) { create(:answer) }
  
  scenario 'A user removes his own answer' do
    sign_in(answer.user)
    visit question_path(answer.question)
    click_on 'Edit'
    click_on 'Delete'

    expect(page).to_not have_content answer.body
    expect(current_path).to eq question_path(answer.question)
  end

  scenario "A user cannot remove an another user's answer" do
    sign_in(answer.user)
    visit question_path(another_answer.question)

    expect(page).to_not have_selector(:link_or_button, 'Edit')
  end

end
