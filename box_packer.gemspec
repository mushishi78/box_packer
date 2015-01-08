# coding: utf-8
version = File.read(File.expand_path("../VERSION", __FILE__)).strip

Gem::Specification.new do |s|
  s.name         = 'box_packer'
  s.version      = version
  s.author       = 'Max White'
  s.email        = 'mushishi78@gmail.com'
  s.license      = 'MIT'
  s.summary      = '3D bin-packing algorithm with optional weight and bin limits.'
  s.files        = Dir['LICENSE.txt', 'README.md', 'lib/**/*']
  s.require_path = 'lib'
  s.add_runtime_dependency 'attire', '~> 0.0', '>= 0.0.3'
  s.add_runtime_dependency 'rasem', '~> 0.6'
  s.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.0'
end
