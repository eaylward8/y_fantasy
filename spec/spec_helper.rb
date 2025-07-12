# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_group "Lib", "lib"
end

require "pry-byebug"
require "webmock/rspec"
require "y_fantasy"
require "support/fixture_loader"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random

  config.before(:each, :api) do |c|
    stub_request(:post, "https://api.login.yahoo.com/oauth2/get_token")
      .with(body: hash_including("grant_type" => "authorization_code", "code" => "fake_code"))
      .to_return(status: 200, body: FixtureLoader.load("authentication/get_token.json"))

    stub_request(:post, "https://api.login.yahoo.com/oauth2/get_token")
      .with(body: hash_including("grant_type" => "refresh_token", "refresh_token" => "fake_refresh_token"))
      .to_return(status: 200, body: FixtureLoader.load("authentication/get_token.json"))
  end
end
