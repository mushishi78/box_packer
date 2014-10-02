BoxPacker
=========

A heuristic first-fit 3D bin packing algorithm with optional weight and bin limits. 

Installation
------------

Install gem:

``` console
gem  install 'box_packer'
```

Or add to gemfile:

``` ruby
gem  'box_packer'
```

Usage
-----

``` ruby
require 'box_packer'

BoxPacker.container [3, 6, 7] do 
	add_item [1,3,5]
	add_item [4,3,5]
	add_item [3,5,5]
	pack! # returns 2

	puts packed_successfully	         # true
	puts packings.count	                 # 2
	puts packings[0].include? items[1]   # false
	puts packings[0][1].position         # (5,0,0)

	puts self  	# |Container| 7x6x3
				# |  Packing| Remaining Volume:36
				# |     Item| 5x5x3 (0,0,0) Volume:75
				# |     Item| 1x5x3 (5,0,0) Volume:15
				# |  Packing| Remaining Volume:66
				# |     Item| 5x4x3 (0,0,0) Volume:60
	
end
```

With optional labels, weights and packings limit:

``` ruby
BoxPacker.container [15, 20, 13], label: 'Parcel', weight_limit: 50, packings_limit: 3 do 
	add_item [2, 3, 5], label: 'Shoes', weight: 47
	add_item [3, 3, 1], label: 'Watch', weight: 24
	add_item [1, 1, 4], label: 'Bag',   weight:  7
	pack! # returns 2

	puts self  	# |Container| Parcel 20x15x13 Weight Limit:50 Packings Limit:3
				# |  Packing| Remaining Volume:3870 Remaining Weight:3
				# |     Item| Shoes 5x3x2 (0,0,0) Volume:30 Weight:47
				# |  Packing| Remaining Volume:3887 Remaining Weight:19
				# |     Item| Watch 3x3x1 (0,0,0) Volume:9 Weight:24
				# |     Item| Bag 4x1x1 (3,0,0) Volume:4 Weight:7
end
```

Alternative builder API:

``` ruby
BoxPacker.builder do |b|
	c1 = b.container [10,5,11]
	c2 = b.container [17,23,14]

	c1.items = [b.item([1,1,4]), b.item([4,6,7]), b.item([5,8,10])]
	c2.items = c1.items

	c1.pack! # 2
	c2.pack! # 1

	puts c1  # |Container| 11x10x5
			 # |  Packing| Remaining Volume:146
			 # |     Item| 10x8x5 (0,0,0) Volume:400
			 # |     Item| 4x1x1 (0,8,0) Volume:4
			 # |  Packing| Remaining Volume:382
			 # |     Item| 7x6x4 (10,0,0) Volume:168

	puts c2  # |Container| 23x17x14
			 # |  Packing| Remaining Volume:4902
			 # |     Item| 10x8x5 (0,0,0) Volume:400
			 # |     Item| 7x6x4 (10,0,0) Volume:168
			 # |     Item| 4x1x1 (17,0,0) Volume:4

end
```