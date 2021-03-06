require 'rails_helper'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.include FeaturesMacros, type: :feature

  Capybara.javascript_driver = :webkit

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    FileUtils.rm_rf(Dir.glob('public/uploads/*'))
    DatabaseCleaner.start
  end

  config.after(:each) do
    FileUtils.rm_rf(Dir.glob('public/uploads/*'))
    DatabaseCleaner.clean
  end
end
