# frozen_string_literal: true
ENV["ENVIRONMENT"] = "test"

require 'capybara'
require 'capybara/rspec'
require 'pry'
require 'rspec'
require 'sinatra/reloader'
require 'simplecov'
require 'simplecov-console'
require 'features/web_helpers'
require 'rake'

require File.join(File.dirname(__FILE__), "..", "app.rb")


Capybara.app = Makersbnb

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::Console,
    SimpleCov::Formatter::HTMLFormatter
  ]
)
SimpleCov.start do
  add_filter 'rakefile'
end

Rake.application.load_rakefile

RSpec.configure do |config|
  config.before(:each) do
    Rake::Task['test_database_setup'].execute
  end

  config.after(:suite) do
    puts
    puts "\e[33mHave you considered running rubocop? It will help you improve your code!\e[0m"
    puts "\e[33mTry it now! Just run: rubocop\e[0m"
  end
end
