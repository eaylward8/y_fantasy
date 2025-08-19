# frozen_string_literal: true

require_relative "lib/y_fantasy/version"

Gem::Specification.new do |spec|
  spec.name = "y_fantasy"
  spec.version = YFantasy::VERSION
  spec.authors = ["Erik Aylward"]
  spec.email = ["y_fantasy_gem@proton.me"]

  spec.summary = "Ruby wrapper for the Yahoo Fantasy Sports API"
  spec.homepage = "https://github.com/eaylward8/y_fantasy"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/eaylward8/y_fantasy"
  spec.metadata["changelog_uri"] = "https://github.com/eaylward8/y_fantasy/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-initializer", "~> 3.1.1"
  spec.add_dependency "dry-configurable", "~> 1.1.0"
  spec.add_dependency "dry-transformer", "~> 1.0.1"
  spec.add_dependency "dry-types", "~> 1.7.2"
  spec.add_dependency "dry-validation", "~> 1.10.0"
  spec.add_dependency "mechanize", "~> 2.9"
  spec.add_dependency "ox", "~> 2.14"
  spec.add_dependency "thor", "~> 1.3"
  spec.add_dependency "zeitwerk", "~> 2.7"

  spec.add_development_dependency "bundler", "~> 2.7"
  spec.add_development_dependency "factory_bot", "~> 6.5"
  spec.add_development_dependency "pry-byebug", "~> 3.10"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.20"
  spec.add_development_dependency "standard", "~> 1.10"
  spec.add_development_dependency "webmock", "~> 3.0"
end
