# frozen_string_literal: true

require_relative "lib/y_fantasy/version"

Gem::Specification.new do |spec|
  spec.name = "y_fantasy"
  spec.version = YFantasy::VERSION
  spec.authors = ["Erik Aylward"]
  spec.email = ["y_fantasy_gem@proton.me"]

  spec.summary = "Ruby wrapper for the Yahoo Fantasy Sports API"
  spec.homepage = "https://gitlab.com/eaylward8/y_fantasy"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://gitlab.com/eaylward8/y_fantasy"
  spec.metadata["changelog_uri"] = "https://gitlab.com/eaylward8/y_fantasy/-/blob/master/CHANGELOG.md"

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

  spec.add_dependency "dry-initializer", "~> 3.0"
  spec.add_dependency "dry-transformer", "~> 1.0"
  spec.add_dependency "dry-types", "~> 1.0"
  spec.add_dependency "dry-validation", "~> 1.0"
  spec.add_dependency "mechanize"
  spec.add_dependency "ox"
  spec.add_dependency "zeitwerk", "~> 2.5"

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.20"
  spec.add_development_dependency "standard", "~> 1.10"
  spec.add_development_dependency "webmock", "~> 3.0"
end
