# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "bundler/setup"
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "sidekiq/clockwork"
require "minitest/utils"
require "minitest/autorun"
