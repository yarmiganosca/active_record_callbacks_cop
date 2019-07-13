require 'active_record_callbacks_cop'
require 'rubocop/rspec/support'

if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start
end

RSpec.configure do |config|
  config.include RuboCop::RSpec::ExpectOffense
end

