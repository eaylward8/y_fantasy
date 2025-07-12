# frozen_string_literal: true

require "forwardable"
require "json"

require "dry-initializer"
require "dry-configurable"
require "dry-transformer"
require "dry-types"
require "dry-validation"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.collapse("#{__dir__}/y_fantasy/concerns")
loader.collapse("#{__dir__}/y_fantasy/resources")
loader.collapse("#{__dir__}/y_fantasy/resources/shared_subresources")
loader.setup

module YFantasy
  extend Dry::Configurable

  setting :yahoo_client_id, default: ENV["YAHOO_CLIENT_ID"]
  setting :yahoo_client_secret, default: ENV["YAHOO_CLIENT_SECRET"]
  setting :yahoo_username, default: ENV["YAHOO_USERNAME"]
  setting :yahoo_password, default: ENV["YAHOO_PASSWORD"]
  setting :yahoo_refresh_token, default: ENV["YAHOO_REFRESH_TOKEN"]
  setting :automate_login, default: false

  module Types
    include Dry.Types()
  end
end

loader.eager_load_dir("#{__dir__}/y_fantasy/resources")
