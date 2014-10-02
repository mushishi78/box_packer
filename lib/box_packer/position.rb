require 'matrix'

module BoxPacker
	class Position < Vector

		def to_s
			"(#{self[0]},#{self[1]},#{self[2]})"
		end

	end
end