# BoxPacker

First fit heuristic algorithm for 3D bin-packing with weight limit.

## Version 2

For version 2 this entire solution has been rewritten with an emphasis on making a much simpler
and easier to understand implementation. However, I haven't gone to the trouble of reproducing
all the previous functionality, so if you still need that, it can be found here:
[1.2.4](https://github.com/mushishi78/box_packer/tree/1.2.4)

## Installation

Add to gemfile:

``` ruby
gem  'box_packer'
```

## Usage

``` ruby
require 'box_packer'

packings = BoxPacker.pack(
  container: { dimensions: [15, 20, 13], weight_limit: 50 },
  items: [
    { dimensions: [2, 3, 5], weight: 47 },
    { dimensions: [2, 3, 5], weight: 47 },
    { dimensions: [3, 3, 1], weight: 24 },
    { dimensions: [1, 1, 4], weight: 7 },
  ]
)

packings.length # 3
packings[0][:weight] # 47
packings[0][:placements].length # 1
packings[0][:placements][0][:dimensions] # [5, 3, 2]
packings[0][:placements][0][:position] # [0, 0, 0]
packings[1][:weight] # 47
packings[1][:placements].length # 1
packings[1][:placements][0][:dimensions] # [5, 3, 2]
packings[1][:placements][0][:position] # [0, 0, 0]
packings[2][:weight] # 31
packings[2][:placements].length # 2
packings[2][:placements][0][:dimensions] # [3, 3, 1]
packings[2][:placements][0][:position] # [0, 0, 0]
packings[2][:placements][1][:dimensions] # [4, 1, 1]
packings[2][:placements][1][:position] # [3, 0, 0]
```
