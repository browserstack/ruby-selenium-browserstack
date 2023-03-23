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
(Context: For running test session). <br>
i. Navigate to ./scripts/parallel.rb <br>
ii. Change the capabilities and swap the credentials.

  You can export Browserstack Username and Access key or hard code them in script.
```
export BROWSERSTACK_USERNAME="YOUR_USER_NAME";
export BROWSERSTACK_ACCESS_KEY="YOUR_ACCESS_KEY";
```
  
3. Run test session
For running tests
```
bundle exec ruby ./scripts/parallel.rb
```

For running local test (in ./scripts/local.rb)
```
bundle exec ruby ./scripts/local.rb
```
