require_relative 'container'
require_relative 'item'

module BoxPacker

	def self.builder(&b)
		instance_exec(&b) if block_given?
	end
	
	def self.item(*args)
		Item.new(*args)
	end

	def self.container(*args)
		Container.new(*args)
	end

end