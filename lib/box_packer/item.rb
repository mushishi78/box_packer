require_relative 'box'
require_relative 'dimensions'

module BoxPacker
	class Item < Box
		attr_accessor :label, :weight

		def initialize(dimensions, opts={})
			super(Dimensions[*dimensions])
			@label = opts[:label]
			@weight = opts[:weight]
		end

		def fit_into?(box)
			each_rotation do |rotation|
				if box.dimensions >= rotation
					@dimensions = rotation
					return true
				end
			end
			false
		end

		def to_s
			s = '|     Item|'
			s << " #{label}" if label
			s << " #{dimensions} #{position} Volume:#{volume}"
			s << " Weight:#{weight}" if weight
			s << "\n"
		end
		
	end
end