require 'simplecov'
SimpleCov.start

require_relative '../lib/wcn_scraper'
require_relative '../lib/vacancy_formatter'
require_relative '../lib/notify_slack'
require_relative '../lib/push_to_dashboard'
require 'rspec'

ENV['DASHBOARD_KEY'] = 'Nothing to see here'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
