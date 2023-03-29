require 'rubygems'
require 'selenium-webdriver'
require "browserstack/local"

USER_NAME = ENV['BROWSERSTACK_USERNAME'] || "YOUR_USER_NAME"
ACCESS_KEY = ENV['BROWSERSTACK_ACCESS_KEY'] || "YOUR_ACCESS_KEY"

# Creates an instance of Local
bs_local = BrowserStack::Local.new

# You can also set an environment variable - "BROWSERSTACK_ACCESS_KEY".
bs_local_args = { "key" => ACCESS_KEY, "force" => "true" }

# Starts the Local instance with the required arguments
bs_local.start(bs_local_args)

# Check if BrowserStack local instance is running
puts "Local running: #{bs_local.isRunning}"
# Input capabilities
caps = Selenium::WebDriver::Remote::Capabilities.new
caps['device'] = 'iPhone 11'
caps['realMobile'] = 'true'
caps['os_version'] = '14.0'
caps['javascriptEnabled'] = 'true'
caps['browserstack.local'] = 'true'
caps['name'] = 'BStack local ruby' # test name
caps['build'] = 'browserstack-build-1' # CI/CD job or build name
caps['browserstack.source'] = 'ruby:sample-selenium-3:v1.1'

driver = Selenium::WebDriver.for(:remote,
  :url => "https://#{USER_NAME}:#{ACCESS_KEY}@hub.browserstack.com/wd/hub",
  :desired_capabilities => caps)
begin
    # opening the bstackdemo.com website
    driver.navigate.to "http://bs-local.com:45691/check"
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
    
    body = driver.find_element(:css, 'body')
    wait.until { body.displayed? }
    body_text = body.text

    if body_text.eql? "Up and running"
        # marking test as 'passed' local ran succesfully
        driver.execute_script('browserstack_executor: {"action": "setSessionStatus", "arguments": {"status":"passed", "reason": "Local ran successfully"}}')
    else
        # marking test as 'failed' 
        driver.execute_script('browserstack_executor: {"action": "setSessionStatus", "arguments": {"status":"failed", "reason": "Local setup failed"}}')
    end
# marking test as 'failed' if test script is unable to open the bstackdemo.com website
rescue
  driver.execute_script('browserstack_executor: {"action": "setSessionStatus", "arguments": {"status":"failed", "reason": "Some elements failed to load"}}')
end
driver.quit 

# Stop the Local instance
bs_local.stop
