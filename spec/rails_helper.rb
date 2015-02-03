ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'rails/mongoid'
require 'shoulda/matchers'
require "email_spec"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)

  config.include JsonSpec::Helpers

  require 'database_cleaner'
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    # DatabaseCleaner.orm = 'mongoid'
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end

  config.include AcceptMacros
  # config.include Mongoid::Matchers, type: :model
end
