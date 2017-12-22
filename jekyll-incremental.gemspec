# Frozen-string-literal: true
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "jekyll/incremental/version"

Gem::Specification.new do |s|
  s.require_paths = ["lib"]
  s.authors = ["Jordon Bedwell"]
  s.version = Jekyll::Incremental::VERSION
  s.homepage = "http://github.com/anomaly/jekyll-incremental/"
  s.files = %w(Rakefile Gemfile README.md LICENSE) + Dir["lib/**/*"]
  s.summary = "A rewritten version of Incremental regeneration"
  s.required_ruby_version = ">= 2.3.0"
  s.email = ["jordon@envygeeks.io"]
  s.name = "jekyll-incremental"
  s.license = "Apache-2.0"

  s.add_runtime_dependency("jekyll", "~> 3.6")
  s.add_runtime_dependency("jekyll-cache", "~> 1.1")
  s.add_development_dependency("simplecov", "~> 0")
  s.add_development_dependency("luna-rspec-formatters", "~> 3")
  s.add_development_dependency("nokogiri", "~> 1")
  s.add_development_dependency("rspec", "~> 3")
end
