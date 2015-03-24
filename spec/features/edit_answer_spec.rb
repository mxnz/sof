require_relative 'features_helper'

RSpec.feature 'Edit answer', %{
  In order to change my answer
  As an author
  I want to be able to edit one
}, js: true do

  given(:answer) { create(:answer) }
  given(:another_answer) { create(:answer) }

  describe 'An authenticated user' do
    before { sign_in(answer.user) }

    describe 'updates his own answer' do
      before do
        visit question_path(answer.question)
        click_on 'Edit'
      end

      it { expect(page).to have_field 'Text', with: answer.body }

      scenario 'with valid data' do
        fill_in 'Text', with: 'New text'
        click_on 'Publish'

        expect(current_path).to eq question_path(answer.question)
        expect(page).to_not have_field 'Text'
        expect(page).to_not have_selector(:link_or_button, 'Publish')
        expect(page).to have_content 'New text'
      end

      scenario 'with invalid data' do
        fill_in 'Text', with: ''
        click_on 'Publish'

        expect(current_path).to eq question_path(answer.question)
        expect(page).to have_field 'Text'
        expect(page).to have_selector(:link_or_button, 'Publish')
        expect(page).to have_content "Text can't be blank"
      end
    end

    scenario "cannot update another user's answer" do
      visit question_path(another_answer.question)

      expect(page).to_not have_selector(:link_or_button, 'Edit')
    end
  end

  scenario 'A non-authenticated user cannot update any answer' do
    visit question_path(answer.question)

    expect(page).to_not have_selector(:link_or_button, 'Edit')
  end

end
