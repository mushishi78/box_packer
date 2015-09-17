require_relative 'dimensions'
require_relative 'item'
require_relative 'packer'
require_relative 'packing'
require_relative 'svg_exporter'
require_relative 'box'

module BoxPacker
  def self.container(*args, &b)
    Container.new(*args, &b)
  end

  class Container < Box
    attr_accessor :label, :weight_limit, :packings_limit
    attr_reader :items, :packing, :packings, :packed_successfully

    def initialize(dimensions, opts = {}, &b)
      super(Dimensions[*dimensions])
      @label = opts[:label]
      @weight_limit = opts[:weight_limit]
      @packings_limit = opts[:packings_limit]
      @items = opts[:items] || []
      orient!
      instance_exec(&b) if b
    end

    def add_item(dimensions, opts = {})
      quantity = opts.delete(:quantity) || 1
      quantity.times do
        items << Item.new(dimensions, opts)
      end
    end

    def <<(item)
      items << item.dup
    end

    def items=(new_items)
      @items = new_items.map(&:dup)
    end

    def pack!
      prepare_to_pack!
      return unless unpackable?
      if @packed_successfully = Packer.pack(self)
        packings.count
      else
        @packings = []
        false
      end
    end

    def new_packing!
      @packing = Packing.new(volume, weight_limit)
      @packings << @packing
    end

    def to_s
      s = "\n|Container|"
      s << " #{label}" if label
      s << " #{dimensions}"
      s << " Weight Limit:#{weight_limit}" if weight_limit
      s << " Packings Limit:#{packings_limit}" if packings_limit
      s << "\n"
      s << (packed_successfully ? packings.map(&:to_s).join : '|         | Did Not Pack!')
    end

    def draw!(filename, opts = {})
      exporter = SVGExporter.new(self, opts)
      exporter.draw
      exporter.save(filename)
    end

    private

    def unpackable?
      items.empty? || any_item_too_large? || any_item_too_heavy? || items_to_heavy?
    end

    def any_item_too_large?
      !items.all? { |item| self >= item }
    end

    def any_item_too_heavy?
      !weight_limit || items.any? { |item| !item.weight || item.weight > weight_limit }
    end

    def items_to_heavy?
      return false unless weight_limit && packings_limit
      items.map(&:weight).reduce(&:+) >= weight_limit * packings_limit
    end

    def prepare_to_pack!
      items.each(&:orient!)
      @packings = []
      @packed_successfully = false
    end
  end
end
