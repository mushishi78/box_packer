require 'attr_extras'
require 'forwardable'
require_relative 'position'
require_relative 'dimensions'

module BoxPacker
	class Box
		extend Forwardable

		def_delegators :dimensions, :volume, :each_rotation, :width, :height, :depth
		attr_accessor :dimensions, :position

		def initialize(dimensions, options={})
			@dimensions = dimensions.is_a?(Dimensions) ? dimensions : Dimensions[*dimensions]
			@position = options[:position]
		end

		def position
			@position ||= Position[0, 0, 0]
		end

		def orient!
			@dimensions = Dimensions[*dimensions.to_a.sort!.reverse!]
		end

		def >=(other_box)
			dimensions >= other_box.dimensions
		end

		def sub_boxes(item)	
			sub_boxes = sub_boxes_args(item).select{ |(d, p)| Dimensions[*d].volume > 0 }
			sub_boxes.map!{ |args| Box.new(*args) }
			sub_boxes.sort_by!(&:volume).reverse!
		end

	private

		def sub_boxes_args(item)
			[[      width +      height + depth - item.width,  position: position + item.width  ],
			 [ item.width +      height + depth - item.height, position: position + item.height ],
			 [ item.width + item.height + depth - item.depth,  position: position + item.depth  ]]
		end

	end
end