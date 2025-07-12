# frozen_string_literal: true

class Fixture
  def self.load(file_name)
    File.read("#{File.dirname(__FILE__)}/fixtures/#{file_name}")
  end

  def self.load_yaml(file_name)
    YAML.load(load(file_name))
  end
end
