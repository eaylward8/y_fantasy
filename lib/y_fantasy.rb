# frozen_string_literal: true

require "forwardable"
require "json"

require "dry-initializer"
require "dry-transformer"
require "dry-types"
require "dry-validation"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module YFantasy
  module Types
    include Dry.Types()
  end
end
