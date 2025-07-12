# frozen_string_literal: true

class Fixture
  def self.load(file_name)
    File.read("#{File.dirname(__FILE__)}/fixtures/#{file_name}")
  end

  def self.load_yaml(file_name)
    deep_symbolize = YFantasy::Transformations::T[:deep_symbolize_keys]
    deep_symbolize.call(YAML.load(load(file_name)))
  end
end
