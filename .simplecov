# frozen_string_literal: true

require 'simplecov'

SimpeCov.start do
  coverage_dir 'target/coverage'
  add_filter '/spec/'
  minimum_coverage 90
end
