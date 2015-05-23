require_relative 'container'
require_relative 'item'

module BoxPacker
  def self.builder(&b)
    b.call(Builder.new) if block_given?
  end

  class Builder
    def container(*args, &b)
      Container.new(*args, &b)
    end

    def item(*args)
      Item.new(*args)
    end
  end
end
