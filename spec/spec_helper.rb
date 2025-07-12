# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter "/spec"
  add_filter "lib/y_fantasy/version"
  track_files "lib/**/*.rb"
  add_group "Resources", "lib/y_fantasy/resources"
  add_group "Transformations", "lib/y_fantasy/transformations"
end

require "y_fantasy"
require "factory_bot"
require "pry-byebug"
require "support/fixture"
require "support/output_suppressor"
require "webmock/rspec"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random

  # FactoryBot config
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end

  # Suppress $stdout output during specs
  config.include OutputSuppressor
  config.around(:example, :suppress_output) do |ex|
    suppress_output { ex.run }
  end

  # Ensure specs don't get stuck waiting for `gets`
  YFantasy.config.manual_login_timeout_seconds = 0.5

  config.before(:each, :api) do |c|
    # Obtain access token with code
    stub_request(:post, "https://api.login.yahoo.com/oauth2/get_token")
      .with(body: hash_including("grant_type" => "authorization_code", "code" => "fake_code"))
      .to_return(status: 200, body: Fixture.load("authentication/get_token.json"))

    # Obtain access token with refresh token
    stub_request(:post, "https://api.login.yahoo.com/oauth2/get_token")
      .with(body: hash_including("grant_type" => "refresh_token", "refresh_token" => "fake_refresh_token"))
      .to_return(status: 200, body: Fixture.load("authentication/get_token.json"))
  end
end
