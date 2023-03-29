require 'rubygems'
require 'selenium-webdriver'

USER_NAME = ENV['BROWSERSTACK_USERNAME'] || "YOUR_USER_NAME"
ACCESS_KEY = ENV['BROWSERSTACK_ACCESS_KEY'] || "YOUR_ACCESS_KEY"

def run_session(browser, version, os, os_version, device, realMobile, javascriptEnabled, test_name, build_name)
    caps = Selenium::WebDriver::Remote::Capabilities.new
    caps['browser'] = browser
    caps['os_version'] = os_version
    caps['os'] = os
    caps['browser_version'] = version
    caps['device'] = device
    caps['realMobile'] = realMobile
    caps['javascriptEnabled'] = 'true'
    caps['name'] = test_name # test name
    caps['build'] = build_name # CI/CD job or build name
    caps['browserstack.source'] = 'ruby:sample-selenium-3:v1.1'

    driver = Selenium::WebDriver.for(:remote,
      :url => "https://#{USER_NAME}:#{ACCESS_KEY}@hub.browserstack.com/wd/hub",:desired_capabilities => caps)
    begin
        # opening the bstackdemo.com website
        driver.navigate.to "https://bstackdemo.com/"
        wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
        wait.until { !driver.title.match(/StackDemo/i).nil? }

        # getting name of the product available on the webpage
        product = driver.find_element(:xpath, '//*[@id="1"]/p')
        wait.until { product.displayed? }
        product_text = product.text

        # waiting until the 'Add to Cart' button is displayed on webpage and then clicking it
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

t1 = Thread.new{run_session("Chrome", "latest", "Windows", "10", nil, nil, "true", "BStack parallel ruby", "browserstack-build-1")}
t2 = Thread.new{run_session("Firefox", "latest", "OS X", "Monterey", nil , nil, "true","BStack parallel ruby", "browserstack-build-1")}
t3 = Thread.new{run_session("Safari", "latest", "OS X", "Catalina", nil, nil, "true", "BStack parallel ruby", "browserstack-build-1")}
t4 = Thread.new{run_session("Android", "latest", nil, nil, "Samsung Galaxy S20", "true", "true", "BStack parallel ruby", "browserstack-build-1")}
t5 = Thread.new{run_session("iPhone", "latest-beta", nil, "14", "iPhone 12 Pro Max", "true", "true", "BStack parallel ruby", "browserstack-build-1")}

t1.join()
t2.join()
t3.join()
t4.join()
t5.join()
