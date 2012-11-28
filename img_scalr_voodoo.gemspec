# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "image_voodoo/version"

Gem::Specification.new do |s|
  s.name        = 'img_scalr_voodoo'
  s.version     = ImgScalrVoodoo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = 'Nulayer'
  s.email       = 'info@nulayer.com'
  s.homepage    = 'http://github.com'
  s.summary     = 'Image manipulation in JRuby based on ImgScalr'
  s.description = 'Image manipulation in JRuby based on ImgScalr'

  s.rubyforge_project = "img_scalr_voodoo"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.has_rdoc      = true
end