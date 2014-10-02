lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'box_packer/version'

Gem::Specification.new do |spec|
  spec.name          = 'box_packer'
  spec.version       = BoxPacker::VERSION
  spec.authors       = ['Max White']
  spec.email         = ['mushishi78@gmail.com']
  spec.description   = 'A Heuristic First-Fit 3D Bin Packing Algorithm with Weight Limit'
  spec.summary       = 'A Heuristic First-Fit 3D Bin Packing Algorithm with Weight Limit'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'

  spec.add_dependency 'attr_extras'

end
