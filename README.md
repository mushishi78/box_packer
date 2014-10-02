BoxPacker
=========

A heuristic first-fit 3D bin packing algorithm with optional weight and bin limits. 

Installation
------------

Install gem or add to gemfile:

``` console
gem  install 'box_packer'
```

Usage
-----

``` ruby
require 'box_packer'

BoxPacker.builder do 
	c = container [3, 6, 7]
	c.items = [item([1, 3, 5]), item([4, 3, 5]), item([3, 5, 5])]
	c.pack! # returns 2

	puts c.packed_successfully	            # true
	puts c.packings.count	                # 2
	puts c.packings[0].include? c.items[1] 	# false
	puts c.packings[0][1].position          # (5,0,0)

	puts c  # |Container| 7x6x3
			# |  Packing| Remaining Volume:36
			# |     Item| 5x5x3 (0,0,0) Volume:75
			# |     Item| 1x5x3 (5,0,0) Volume:15
			# |  Packing| Remaining Volume:66
			# |     Item| 5x4x3 (0,0,0) Volume:60
	
end
```

With optional labels, weights and packings limit:

``` ruby
BoxPacker.builder do 
	c = container [15, 20, 13], label: 'Parcel', weight_limit: 50, packings_limit: 3 
	c << item([2, 3, 5], label: 'Shoes', weight: 47)
	c << item([3, 3, 1], label: 'Watch', weight: 24)
	c << item([0, 1, 4], label: 'Bag',   weight:  7)
	c.pack! # returns 2

	puts c  # |Container| Parcel 20x15x13 Weight Limit:50 Packings Limit:3
			# |  Packing| Remaining Volume:3870 Remaining Weight:3
			# |     Item| Shoes 5x3x2 (0,0,0) Volume:30 Weight:47
			# |  Packing| Remaining Volume:3891 Remaining Weight:19
			# |     Item| Watch 3x3x1 (0,0,0) Volume:9 Weight:24
			# |     Item| Bag 4x1x0 (3,0,0) Volume:0 Weight:7
end
```