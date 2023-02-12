require 'capybara/dsl'

include Capybara::DSL

Capybara.run_server = false

Capybara.register_driver :selenium_firefox do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end
Capybara.current_driver = :selenium_firefox
