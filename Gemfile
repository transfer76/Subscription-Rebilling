# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').strip

gem 'faraday', '~> 2.7'
gem 'json', '~>2.6'
gem 'redis', '~> 5.2'
gem 'sidekiq', '~>7.1'
gem 'sinatra', '~> 2.2'
gem 'sinatra-activerecord', '~> 2.0'
gem 'sinatra-contrib', '~> 2.2', require: false

group :development, :test do
  gem 'dotenv', '~> 3.1', '>= 3.1.7'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'ffaker', '~> 2.21'
  gem 'pry', '~> 0.14'
  gem 'pry-byebug', '~> 3.8', require: false
  gem 'rubocop', '~> 1.30'
  gem 'rubocop-performance', '~> 1.14'
  gem 'rubocop-rspec', '~> 2.11', require: false
  gem 'tux', '~> 0.3', require: false
end

group :test do
  gem 'rspec', '~> 3.13'
  gem 'rack-test', '~> 2.1'
  gem 'shoulda-matchers', '~> 5.1'
  gem 'simplecov', '~> 0.21', require: false
  gem 'webmock'
end
