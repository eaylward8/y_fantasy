# frozen_string_literal: true

require "forwardable"
require "json"

require "dry-initializer"
require "dry-transformer"
require "dry-types"
require "dry-validation"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.collapse("#{__dir__}/y_fantasy/concerns")
loader.collapse("#{__dir__}/y_fantasy/resources")
loader.collapse("#{__dir__}/y_fantasy/subresources")
loader.setup

module YFantasy
  module Types
    include Dry.Types()
  end
end
