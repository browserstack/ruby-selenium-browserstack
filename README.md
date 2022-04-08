# ruby-selenium-browserstack

## Prerequisite
a. Ruby setup on your machine
```
ruby -v
```

b. bundler gem
```
gem install bundler
```

## Steps for running test session

1. Clone the repo, navigate to the cloned folder then install the dependencies:
```
bundle install
```
2. Configure the capabilties for the test and use your credentials <br>
(Context: For running single test session). <br>
i. Navigate to ./scripts/single.rb <br>
ii. Change the capabilities and swap the credentials.
  ```ruby
# change capabilities
caps = Selenium::WebDriver::Remote::Capabilities.new
caps['device'] = 'iPhone 11'
caps['realMobile'] = 'true'
caps['os_version'] = '14.0'
caps['javascriptEnabled'] = 'true'
caps['name'] = 'BStack-[Ruby] Sample Test' # test name
caps['build'] = 'BStack Build Number 1' # CI/CD job or build name
driver = Selenium::WebDriver.for(:remote,
  :url =>  "https://USER_NAME:ACCESS_KEY@hub-cloud.browserstack.com/wd/hub", # Use your browserstack username and accesskey
  :desired_capabilities => caps)

  ```
  
3. Run test session
For running single test
```
bundle exec ruby ./scripts/single.rb
```

For running local test (in ./scripts/local.rb)
```
# Along with step 2 also use your Browserstack access key in bs_local_args
bs_local_args = { "key" => "ACCESS_KEY" }
```
```
bundle exec ruby ./scripts/single.rb
```

For running parallel tests
```
bundle exec ruby ./scripts/parallel.rb
```