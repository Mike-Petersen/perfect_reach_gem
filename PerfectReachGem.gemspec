# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'perfect_reach/version'

Gem::Specification.new do |spec|
	spec.name = "perfect_reach"
	spec.version = PerfectReach::VERSION
	spec.authors = ["Mike Petersen"]
	spec.email = ["mike@odania-it.de"]
	spec.description = %q{Manage Ads, ContactLists via an api}
	spec.summary = %q{Manage Ads, ContactLists via an api}
	spec.homepage = "http://www.perfect-reach.com/"
	spec.license = "MIT"

	spec.files = `git ls-files`.split($/)
	spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ["lib"]

	spec.add_dependency "activesupport", ">= 3.1.0"
	spec.add_development_dependency "bundler", "~> 1.3"
	spec.add_development_dependency "rake"
	spec.add_development_dependency "minitest"
	spec.add_development_dependency "minitest-matchers"
	spec.add_development_dependency "turn"
	spec.add_development_dependency "json"
	spec.add_development_dependency "mocha"
end
