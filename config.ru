# frozen_string_literal: true

require './app/controllers/app'
require 'dotenv/load'

run Sinatra::Application
