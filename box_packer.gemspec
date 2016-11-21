# coding: utf-8

Gem::Specification.new do |s|
  s.name         = 'box_packer'
  s.version      = '2.0.1'
  s.author       = 'Max White'
  s.email        = 'mushishi78@gmail.com'
  s.homepage     = 'https://github.com/mushishi78/box_packer'
  s.license      = 'MIT'
  s.summary      = 'First fit heuristic algorithm for 3D bin-packing with weight limit.'
  s.files        = Dir['LICENSE.txt', 'README.md', 'box_packer.rb']
  s.require_path = '.'
  s.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.0'
end
