# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cypress_rails/version"

Gem::Specification.new do |gem|
  gem.name          = "cypress_rails"
  gem.version       = CypressRails::VERSION
  gem.summary       = "Integrate cypress.io with your rails app"
  gem.description   = "Easily run a test server for cypress to query against"
  gem.license       = "MIT"
  gem.authors       = ["Szymon Szeliga"]
  gem.email         = "szymon@szeliga.co"
  gem.homepage      = "https://rubygems.org/gems/cypress_rails"

  gem.files         = `git ls-files`.split($/)

  `git submodule --quiet foreach --recursive pwd`.split($/).each do |submodule|
    submodule.sub!("#{Dir.pwd}/", "")

    Dir.chdir(submodule) do
      `git ls-files`.split($/).map do |subpath|
        gem.files << File.join(submodule, subpath)
      end
    end
  end
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "thor", "~> 0.20.0"
  gem.add_dependency "railties", ">= 4.2.0"
  gem.add_development_dependency "bundler", "~> 2.0"
  gem.add_development_dependency "codeclimate-test-reporter", "~> 0.1"
  gem.add_development_dependency "pry", "~> 0.11.3"
  gem.add_development_dependency "rack", "~> 2.0"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rdoc", "~> 4.0"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "rubocop", "~> 0.55.0"
  gem.add_development_dependency "rubygems-tasks", "~> 0.2"
  gem.add_development_dependency "rspec_junit_formatter", "~> 0.3.0"
end
