require_relative "box_packer"
require "test/unit"
require 'benchmark'
 
class TestBoxPacker < Test::Unit::TestCase
 
	def setup
		@containers = []
		@containers[0] = BoxPacker::Container.new("A",[10, 1, 1],15)
		@containers[1] = BoxPacker::Container.new("B",[1, 10, 5],50)
		@containers[2] = BoxPacker::Container.new("C",[10, 15, 5],325)

		@items = []
		@items[0] = BoxPacker::Item.new("a",[1, 1, 1],1)
		@items[1] = BoxPacker::Item.new("b",[3, 1, 1],6)
		@items[2] = BoxPacker::Item.new("c",[5, 5, 1],15)
		@items[3] = BoxPacker::Item.new("d",[5, 5, 5],20)

		@skip_items_count = false
	end

	def teardown
    	@containers.delete_if{ |container| container.packings.empty? } 
    	unless @containers.empty?
    		assert(@containers[0].packings.map(&:count).reduce(:+) == @containers[0].items.count, "Packed items less than container's list") unless @skip_items_count
			assert(@containers[0].packings.map(&:remaining_weight).all? { |rw| rw >= 0 }, "Packing too heavy")
		end
  	end

	def test_no_items
		assert_nil(@containers[0].pack)
	end

	def test_items_too_heavy
		@items[0].weight = 16
		@containers[0].items << @items[0] 
		assert_nil(@containers[0].pack)
	end

	def test_items_too_big
		@containers[0].items << @items[2]
		assert_nil(@containers[0].pack)
	end

	def test_too_many_packings
		@containers[0].packings_limit = 1
		11.times { @containers[0].items << @items[0] }
		assert_nil(@containers[0].pack)		
		@skip_items_count = true
	end

	def test_1d_one_full_packing
		7.times { @containers[0].items << @items[0] }
		@containers[0].items << @items[1]
		assert_equal(1, @containers[0].pack)
		assert_equal(0, @containers[0].packings[0].remaining_volume)
	end
 
	def test_1d_two_packings_due_to_weight_limit
		3.times { @containers[0].items << @items[1] }
		assert_equal(2, @containers[0].pack)
	end

	def test_1d_three_full_packings
		@containers[0].packings_limit = 4
		3.times { @containers[0].items << @items[0] << @items[1] }
		18.times { @containers[0].items << @items[0] }
		assert_equal(3, @containers[0].pack)
	end

	def test_2d_one_full_packing_two_identical_items
		2.times { @containers[1].items << @items[2] }
		assert_equal(1, @containers[1].pack)
		assert_equal(0, @containers[1].packings[0].remaining_volume)
	end

	def test_2d_one_full_packing_multiple_items
		4.times { @containers[1].items << @items[0] }
		7.times { @containers[1].items << @items[1] }
		@containers[1].items << @items[2]
		check_pack_in_between(@containers[1], 1, 2)
	end	

	def test_2d_three_full_packings
		@containers[1].packings_limit = 5
		8.times { @containers[1].items << @items[0] }
		14.times { @containers[1].items << @items[1] }
		4.times { @containers[1].items << @items[2] }
		check_pack_in_between(@containers[1], 3, 4)
	end

	def test_3d_one_full_packing_with_identical_items
		6.times { @containers[2].items << @items[3] }
		assert_equal(1, @containers[2].pack)
		assert_equal(0, @containers[2].packings[0].remaining_volume)
	end

	def test_3d_one_full_packing_with_multiple_items
		20.times { @containers[2].items << @items[0] }
		10.times { @containers[2].items << @items[1] }
		8.times { @containers[2].items << @items[2] }
		4.times { @containers[2].items << @items[3] }
		assert_equal(1, @containers[2].pack)
		assert_equal(0, @containers[2].packings[0].remaining_volume)
	end

	def test_3d_three_full_packings
		@containers[2].packings_limit = 5
		35.times { @containers[2].items << @items[0] }
		30.times { @containers[2].items << @items[1] }
		10.times { @containers[2].items << @items[2] }
		15.times { @containers[2].items << @items[3] }
		check_pack_in_between(@containers[2], 3, 4)
	end		

	def test_benchmark
		puts "\n\nBenchmarking\n============"
		iterations = 500
		containers = []

		(1..iterations).each do |i|
	    	container_dimensions = [1 + rand(100), 1 + rand(50), 1 + rand(10)]
	    	container_weight_limit = 1 + rand(1000)
			container = BoxPacker::Container.new("c#{i}", container_dimensions, container_weight_limit)
			container.packings_limit = 50

			(1..(1+rand(40))).each do |j|
				item_dimensions = container_dimensions.map { |c_dimension| 1 + rand(c_dimension) / (1 + rand(5)) }
				item_weight = 1 + rand(container_weight_limit / (1 + rand(10)))
	    		container.items << BoxPacker::Item.new("i#{j}", item_dimensions, item_weight)
			end
			containers << container
	    end

		Benchmark.bm(15) do |bm|
			bm.report('Approx packings') do
				containers.each{ |container| container.pack }
			end
			bm.report('Volume') do
				containers.each{ |container| container.pack(:sort_by_volume) }
			end
			bm.report('Shuffled') do
				containers.each{ |container| container.pack(:sort_by_shuffle) }
			end
		end

		puts "\nBenchmark data\n=============="
		puts "iterations: #{iterations}"		
		benchmark_stats = Hash.new{0}
		containers.each do |container|
			benchmark_stats[:avg_container_volume] += container.volume
			benchmark_stats[:avg_packings_count] += container.packings.count
			benchmark_stats[:avg_items_count] += container.items.count
			benchmark_stats[:avg_item_volume] += container.items.map(&:volume).reduce(:+) / container.items.count.to_f
		end
		benchmark_stats.each do |k, v| 
			benchmark_stats[k] = v / containers.count.to_f 
			puts "#{k}: #{benchmark_stats[k]}"
		end
		puts "\n"
	end

private

	def check_pack_in_between(container, lower_bound, upper_bound)
		assert(container.pack.between?(lower_bound, upper_bound), "Did not pack into #{lower_bound} (or #{upper_bound}) packings")
		assert(container.packings.map(&:remaining_volume).reduce(:+) % container.volume == 0 , "Total remaining volume doesn't add up")
	end

end

