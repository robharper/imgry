# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "imgry/version"

Gem::Specification.new do |s|
  s.name        = 'imgry'
  s.version     = Imgry::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'Fast image resizing/cropping designed for JRuby with MRI support'
  s.description = s.summary

  s.authors     = ['Pressly']
  s.email       = ['info@pressly.com']
  s.homepage    = 'http://github.com/nulayer/imgry'

  s.required_rubygems_version = '>= 1.3.6'

  s.files        = Dir['lib/**/*'] + %w[README.md]
  s.test_files   = Dir['spec/**/*']
  s.require_path = 'lib'

  s.add_development_dependency('rspec', ['~> 2.12'])
end
