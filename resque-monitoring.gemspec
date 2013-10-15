# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resque/monitoring/version'

Gem::Specification.new do |spec|
  spec.name          = "resque-monitoring"
  spec.version       = Resque::Monitoring::VERSION
  spec.authors       = ["Narciso Benigno"]
  spec.email         = ["narciso.benigno@gmail.com"]
  spec.description   = %q{A gem that includes some monitorings to resque and plugins}
  spec.summary       = %q{You add monitorings to app that uses resque}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/*'].select { |f| File.file?(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_dependency "resque", "~> 1.24.0"
  spec.add_dependency "activesupport", ">= 3.2"
end
