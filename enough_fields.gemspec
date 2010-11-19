# -*- encoding: utf-8 -*-
require File.expand_path("../lib/enough_fields/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "enough_fields"
  s.version     = EnoughFields::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = []
  s.email       = []
  s.homepage    = "http://rubygems.org/gems/enough_fields"
  s.summary     = "TODO: Write a gem summary"
  s.description = "TODO: Write a gem description"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "enough_fields"
  
  s.add_dependency "uniform_notifier", "~> 1.0.0"

  s.add_development_dependency "bson", "1.1.2"
  s.add_development_dependency "bson_ext", "1.1.2"
  s.add_development_dependency "mongoid", "2.0.0.beta.20"
  s.add_development_dependency "rspec", "~> 2.1.0"
  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
