require 'rubygems'
require 'selenium-webdriver'

def run_session(browser, browser_version, platform_name, os, osVersion, buildName, sessionName, seleniumVersion)
  options = Selenium::WebDriver::Options.send browser
  options.browser_version = browser_version
  options.platform_name = platform_name
  bstack_options = {
      "os" => os,
      "osVersion" => osVersion,
      "buildName" => buildName,
      "sessionName" => sessionName,
      "seleniumVersion" => seleniumVersion,
  }
  options.add_option('bstack:options', bstack_options)

  USER_NAME = ENV['BROWSERSTACK_USER_NAME'] || "YOUR_USER_NAME"
  ACCESS_KEY = ENV['BROWSERSTACK_ACCESS_KEY'] || "YOUR_ACCESS_KEY"
  driver = Selenium::WebDriver.for(:remote,
    :url => "https://#{USER_NAME}:#{ACCESS_KEY}@hub-cloud.browserstack.com/wd/hub",
    :capabilities => options)
  begin
      # opening the bstackdemo.com website
      driver.navigate.to "https://bstackdemo.com"
      wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
      wait.until { !driver.title.match(/StackDemo/i).nil? }
      # getting name of the product available on the webpage
      product = driver.find_element(:xpath, '//*[@id="1"]/p')
      wait.until { product.displayed? }
      product_text = product.text
      # waiting until the Add to Cart button is displayed on webpage and then clicking it
      cart_btn = driver.find_element(:xpath, '//*[@id="1"]/div[4]')
      wait.until { cart_btn.displayed? }
      cart_btn.click
      # waiting until the Cart pane appears
      wait.until { driver.find_element(:xpath, '//*[@id="__next"]/div/div/div[2]/div[2]/div[2]/div/div[3]/p[1]').displayed? }
      # getting name of the product in the cart
      product_in_cart = driver.find_element(:xpath, '//*[@id="__next"]/div/div/div[2]/div[2]/div[2]/div/div[3]/p[1]')
      wait.until { product_in_cart.displayed? }
      product_in_cart_text = product_in_cart.text
      # checking if the product has been added to the cart
      if product_text.eql? product_in_cart_text
          # marking test as 'passed' if the product is successfully added to the cart
          driver.execute_script('browserstack_executor: {"action": "setSessionStatus", "arguments": {"status":"passed", "reason": "Product has been successfully added to the cart!"}}')
      else
          # marking test as 'failed' if the product is not added to the cart
          driver.execute_script('browserstack_executor: {"action": "setSessionStatus", "arguments": {"status":"failed", "reason": "Failed to add product to the cart"}}')
      end
  # marking test as 'failed' if test script is unable to open the bstackdemo.com website
  rescue
      driver.execute_script('browserstack_executor: {"action": "setSessionStatus", "arguments": {"status":"failed", "reason": "Some elements failed to load"}}')
  end
  driver.quit 
end

t1 = Thread.new{ run_session("chrome", "latest", "MAC", "OS X", "Sierra", "parallel-snippet-test", "ruby 2", "4.0.0") }
t2 = Thread.new{ run_session("firefox", "latest", "MAC", "OS X", "Sierra", "parallel-snippet-test", "ruby 3", "4.0.0") }

t1.join()
t2.join()
