# frozen_string_literal: true

require 'pronto'
require 'rspec/its'
require 'pronto/eslinter'

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.filter_run focus: true
  config.order = 'random'
  config.run_all_when_everything_filtered = true
end
