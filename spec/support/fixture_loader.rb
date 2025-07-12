# frozen_string_literal: true

class FixtureLoader
  def self.load(file_name)
    File.read("#{File.dirname(__FILE__)}/fixtures/#{file_name}")
  end
end
