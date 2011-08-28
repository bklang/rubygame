#######
# GEM #
#######
$:.push File.dirname(__FILE__)
require 'date'
require 'rubygems/package_task'
require 'lib/rubygame/main.rb'

Gem::Specification.new do |s|
  s.name         = "rubygame"
  s.version      = Rubygame::VERSIONS[:rubygame].join(".")
  s.author       = "John Croisant"
  s.email        = "jacius@gmail.com"
  s.homepage     = "http://rubygame.org/"
  s.description  = "Clean and powerful library for game programming"
  s.summary      = "Clean and powerful library for game programming"
  s.date         = Date.today.to_s
  s.rubyforge_project = "rubygame"

  s.files = FileList.new do |fl|
    fl.include("{lib,samples,doc}/**/*")
  end

  s.require_paths = ["lib"]

  s.has_rdoc = true
  s.extra_rdoc_files = FileList.new do |fl|
    fl.include "doc/*.rdoc", "./*.rdoc", "LICENSE.txt"
  end

  s.required_ruby_version = ">= 1.8"
  s.add_dependency( "rake", ">=0.7.0" )
  s.add_dependency( "ruby-sdl-ffi", ">=0.4.0" )
  s.requirements = ["SDL       >= 1.2.7",
                    "SDL_gfx   >= 2.0.10 (optional)",
                    "SDL_image >= 1.2.3  (optional)",
                    "SDL_mixer >= 1.2.7  (optional)",
                    "SDL_ttf   >= 2.0.6  (optional)"]

end
