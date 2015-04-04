require_relative 'features_helper'

RSpec.feature 'Attach files to an answer', %{
  In order to illustrate my answer
  As an answer author
  I want to be able to attach files to my answer
}, type: :feature, js: true do

  given(:answer) { create(:answer) }
  before do
    sign_in answer.user
    visit question_path(answer.question)
  end

  scenario 'Attach files to a new answer' do
    click_on 'Answer'
    fill_in 'Text', with: 'Answer Text'

    click_on 'Attach file'
    within all(".attachment_controls .field").last do
      attach_file('File', "#{Rails.root}/spec/spec_helper.rb")
    end

    click_on 'Attach file'
    within all(".attachment_controls .field").last do
      attach_file('File', "#{Rails.root}/spec/rails_helper.rb")
    end

    click_on 'Publish'

    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb'
  end

  scenario 'Attach files to an existing answer' do
    within "#answer_#{answer.id}" do 
      click_on 'Edit'
    end

    click_on 'Attach file'
    within all(".attachment_controls .field").last do
      attach_file('File', "#{Rails.root}/spec/rails_helper.rb")
    end

    click_on 'Attach file'
    within all(".attachment_controls .field").last do
      attach_file('File', "#{Rails.root}/spec/spec_helper.rb")
    end

    click_on 'Attach file'
    within all(".attachment_controls .field").last do
      attach_file('File', "#{Rails.root}/spec/support/features_macros.rb")
    end

    click_on 'Publish'

    within "#answer_#{answer.id}" do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'features_macros.rb'
    end

  end
end
