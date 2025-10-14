require 'capybara/rails'
require 'capybara/rspec'

Capybara.default_max_wait_time = 5

Capybara.register_driver :selenium_chrome_headless do |app|
  opts = Selenium::WebDriver::Chrome::Options.new
  opts.add_argument('--headless=new')
  opts.add_argument('--disable-gpu')
  opts.add_argument('--no-sandbox')
  opts.add_argument('--window-size=1400,1400')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: opts)
end

Capybara.javascript_driver = :selenium_chrome_headless
Capybara.default_driver    = :rack_test