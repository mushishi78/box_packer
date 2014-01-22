require_relative "box_packer/version"
require "matrix"
require "forwardable"

module BoxPacker
  
	class Box 	
		attr_reader :volume
		attr_accessor :dimensions, :position

		def initialize(dimensions, position=[0,0,0])
			@dimensions, @position = Vector.elements(dimensions), Vector.elements(position)
			@volume = @dimensions.reduce(:*)
		end

		def fit?(box)
			(0..2).all?{ |i| box.dimensions[i] <= @dimensions[i] }
		end

		def fit_with_rotation?(box)
			rotations = [0,0,1]
			rotations = rotations.permutation.to_a.uniq.permutation.to_a.reverse
			original_orientation = box.dimensions

			rotations.each do |rotation|
				box.dimensions = Matrix.rows(rotation) * box.dimensions
				return true if fit?(box)
			end

			box.dimensions = original_orientation
			return false
		end

		def break_up_remaining_space(box)				
			x_offset = Vector[box.position[0], 0, 0]

			sub_box_x = Box.new((Matrix.diagonal(1,1,1) * @dimensions) +(Matrix.diagonal(-1,0,0) * box.dimensions), 
				                (Matrix.diagonal(0,1,1) * @position) +(Matrix.diagonal(1,0,0) * box.dimensions) + x_offset)

			sub_box_y = Box.new((Matrix.diagonal(0,1,1) * @dimensions) +(Matrix.diagonal(1,-1,0) * box.dimensions), 
				                (Matrix.diagonal(0,1,1) * @position) +(Matrix.diagonal(0,1,0) * box.dimensions) + x_offset)

			sub_box_z = Box.new((Matrix.diagonal(0,0,1) * @dimensions) +(Matrix.diagonal(1,1,-1) * box.dimensions), 
				                (Matrix.diagonal(0,1,1) * @position) +(Matrix.diagonal(0,0,1) * box.dimensions) + x_offset)

			return [sub_box_x, sub_box_y, sub_box_z]
		end

		def to_s
			"Box - #{@dimensions.to_a} Pos:#{@position.to_a} V:#{@volume}"
		end
	end

	class Item < Box
		attr_accessor :id, :weight

		def initialize(id, dimensions, weight)
			super(dimensions.sort)
			@id, @weight = id, weight
		end

		def deep_copy
    		cloned_item = self.clone
    		cloned_item.dimensions = @dimensions.clone
    		cloned_item.position = @position.clone
    		return cloned_item
		end

		def to_s
			"#{@id} - #{@dimensions.to_a} V:#{@volume} W:#{@weight}"
		end
	end

	class Packing
		extend Forwardable
		attr_reader :remaining_weight, :remaining_volume, :items

		def_delegators :@items, :include?, :each, :map, :count
		
		def initialize(weight_limit, container_volume)
		    @items = []
		    @remaining_weight, @remaining_volume = weight_limit, container_volume
		end

  		def <<(item)
  			@items << item
  			@remaining_volume -= item.volume
  			@remaining_weight -= item.weight
  		end

  		def to_s
			s = @items.map do |item|
				"#{item.id} - #{item.dimensions.to_a} Pos:#{item.position.to_a} V:#{item.volume} W:#{item.weight}"
			end
			return s.join("\n")
  		end
	end

	class Container < Box
		attr_accessor :id, :weight_limit, :packings_limit, :items
		attr_reader :packings

		def initialize(id, dimensions, weight_limit, packings_limit=3)
			super(dimensions.sort)
			@id, @weight_limit, @packings_limit = id, weight_limit, packings_limit
			@items, @packings = [], []
		end

		def pack(sorting_method = :sort_by_volume_into_approx_packings)
			return if @items.empty? || !items_all_fit? || !items_all_light_enough?

			@items_to_pack = self.send(sorting_method, @items).map(&:deep_copy)	
			@packings = []

			until @items_to_pack.empty? || @packings.count >= @packings_limit do
				@current_packing = Packing.new(@weight_limit, @volume)

				pack_box(@items_to_pack.clone, self)
				@packings << @current_packing
			end

			@items_to_pack.empty? ? @packings.count : nil
		end

		def to_s
			s = "\n*** #{@id} - #{@dimensions.to_a} V:#{@volume} WL:#{@weight_limit} PL:#{@packings_limit} ***\n\n"
			s += @items.map(&:to_s).join("\n")
			@packings.each_with_index { |packing, i| s += "\n\nPacking #{i} RW:#{packing.remaining_weight} RV:#{packing.remaining_volume}\n#{packing.to_s}"}
			s += "\n\n"
		end

	private

		def items_all_fit?
			@items.all? { |item| fit?(item) } 
		end

		def items_all_light_enough?
			@items.all? { |item| item.weight < @weight_limit } 
		end

		def pack_box(current_items, box_to_pack)
			until current_items.empty?
				item = current_items.pop

				if box_to_pack.fit_with_rotation?(item)									
					add_item_to_packing(box_to_pack, item) 
					break if (current_items - [item]).empty?

					sub_boxes = box_to_pack.break_up_remaining_space(item)
					sub_boxes.sort_by!(&:volume).reverse!
					sub_boxes.each do |box| 
						break if box.volume == 0
						purge_items!(current_items)
						pack_box(current_items.clone, box)
					end
					break
				end
			end
		end

		def add_item_to_packing(box_to_pack, item_to_add)
			item_to_add.position = box_to_pack.position
			@items_to_pack.delete_if { |item| item == item_to_add }
			@current_packing << item_to_add
		end

		def purge_items!(current_items)
			current_items.delete_if { |item| @current_packing.include?(item) \
										  || item.weight > @current_packing.remaining_weight \
										  || item.volume > @current_packing.remaining_volume}
		end

		def sort_by_volume(items_to_sort)
			items_to_sort.sort_by(&:volume)
		end

		def sort_by_shuffle(items_to_sort)
			items_to_sort.shuffle
		end

		def sort_by_volume_into_approx_packings(items_to_sort)
			split_into_approx_packings(items_to_sort.sort_by(&:volume))
		end

		def split_into_approx_packings(items_to_sort)
			total_volume_of_items = items_to_sort.map(&:volume).reduce(:+) 
			approx_number_of_packings = (total_volume_of_items.to_f / @volume).ceil
			approx_packing_size = (items_to_sort.count.to_f / approx_number_of_packings).ceil
			indexs = (0..items_to_sort.count-1).each_slice(approx_number_of_packings).reduce(:zip).flatten.compact
			return indexs.map{ |i| items_to_sort[i] }
		end

	end

end
