require 'active_support/dependencies'

require 'i18n'

I18n.available_locales = [:it, :en]

ActiveSupport::Dependencies.autoload_paths.unshift(
  File.join(__dir__, "../lib")
)

Dir["spec/support/**/*.rb"].each do |f|
  require_relative "../" + f
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!

  config.order = :random

  Kernel.srand config.seed
end
