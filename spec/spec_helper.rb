require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
 
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
 
  RSpec.configure do |config|
    #config.fixture_path = "#{::Rails.root}/spec/fixtures"
    #config.use_transactional_fixtures = true
    # config.infer_base_class_for_anonymous_controllers = false
  end
end
 
Spork.each_run do
  #Подгружаем каждый раз все файлы из директории app/
  Dir["#{Rails.root}/app/**/*.rb"].each {|file| load file }
  #Подгружаем файл с описанием маршрутизации
  load "#{Rails.root}/config/routes.rb"
end




# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.git clone https://github.com/maltize/sublime-text-2-ruby-tests.git RubyTest
  config.use_transactional_fixtures = true
end
