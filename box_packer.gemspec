lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'box_packer/version'

Gem::Specification.new do |spec|
  spec.name          = 'box_packer'
  spec.version       = BoxPacker::VERSION
  spec.authors       = ['Max White']
  spec.email         = ['mushishi78@gmail.com']
  spec.summary       = 'Heuristic first-fit 3D bin-packing algorithm' \
                       'with optional weight and bin limits.'
  spec.homepage      = 'https://github.com/mushishi78/box_packer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)/)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec', '~> 3.1'

  spec.add_dependency 'attire', '~> 0'
  spec.add_dependency 'rasem', '~> 0.6'
end
