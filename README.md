BoxPacker
=========

A Heuristic First-Fit 3D Bin Packing Algorithm with Weight Limit. 

Installation
------------

Add this line to your application's Gemfile:

    gem 'box_packer'

And then execute:

    $ bundle

Usage
-----

```Ruby
container = BoxPacker::Container.new("MyContainer", [6, 3, 7], 50)

container.items << BoxPacker::Item.new("MyItem01", [1, 5, 3], 10)
container.items << BoxPacker::Item.new("MyItem02", [2, 5, 2], 13)
container.items << BoxPacker::Item.new("MyItem03", [5, 5, 3], 36)

container.pack          #=> 2
puts container
```

``` console
*** MyContainer - [3, 6, 7] V:126 WL:50 PL:3 ***

MyItem01 - [1, 3, 5] V:15 W:10
MyItem02 - [2, 2, 5] V:20 W:13
MyItem03 - [3, 5, 5] V:75 W:36

Packing 0 RW:1 RV:31
MyItem03 - [3, 5, 5] Pos:[0, 0, 0] V:75 W:36
MyItem02 - [2, 5, 2] Pos:[0, 0, 5] V:20 W:13

Packing 1 RW:40 RV:111
MyItem01 - [1, 3, 5] Pos:[0, 0, 0] V:15 W:10
```