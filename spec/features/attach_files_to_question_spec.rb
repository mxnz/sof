require_relative 'features_helper'

RSpec.feature 'Attach files to a question', %{
  In order to illustrate my question
  As a question author
  I want to be able to attach files to my question
}, type: :feature, js: true do
  
  given(:question) { create(:question) }
  
  before { sign_in question.user }
    
  scenario 'Attach files to a new question' do
    visit new_question_path
    fill_in 'Title', with: 'Question Title'
    fill_in 'Text', with: 'Question Text'

    click_on 'Attach file'
    within all(".attachment_controls .field").last do
      attach_file('File', "#{Rails.root}/spec/spec_helper.rb")
    end

    click_on 'Attach file'
    within all(".attachment_controls .field").last do
      attach_file('File', "#{Rails.root}/spec/rails_helper.rb")
    end

    click_on 'Attach file'
    within all(".attachment_controls .field").last do
      attach_file('File', "#{Rails.root}/spec/support/features_macros.rb")
    end

    click_on 'Publish'

    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'features_macros.rb'
  end
  
  scenario 'Attach files to an existing question' do
    visit question_path(question)
    click_on 'Edit Question'

    click_on 'Attach file'
    within all(".attachment_controls .field").last do
      attach_file('File', "#{Rails.root}/spec/spec_helper.rb")
    end

    click_on 'Attach file'
    within all(".attachment_controls .field").last do
      attach_file('File', "#{Rails.root}/spec/rails_helper.rb")
    end

    click_on 'Attach file'
    within all(".attachment_controls .field").last do
      attach_file('File', "#{Rails.root}/spec/support/features_macros.rb")
    end

    click_on 'Publish'

    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'features_macros.rb'
  end

end
