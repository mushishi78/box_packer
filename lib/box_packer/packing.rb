require 'delegate'

module BoxPacker
	class Packing < SimpleDelegator
		attr_reader :remaining_weight, :remaining_volume

		def initialize(total_volume, total_weight)
			super([])
			@remaining_volume = total_volume
			@remaining_weight = total_weight
		end

		def <<(item)
			@remaining_volume -= item.volume
			@remaining_weight -= item.weight if weight?(item)
			super
		end

		def fit?(item)
			return false if include?(item)
			return false if remaining_volume < item.volume
			return false if weight?(item) && remaining_weight < item.weight
			true
		end

		def to_s
			s = "|  Packing| Remaining Volume:#{remaining_volume}"
			s << " Remaining Weight:#{remaining_weight}" if remaining_weight
			s << "\n" 
			s << map(&:to_s).join 
		end
		
	private

		def weight?(item)
			remaining_weight && item.weight
		end

	end
end