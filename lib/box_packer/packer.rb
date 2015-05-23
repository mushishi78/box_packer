module BoxPacker
  class Packer
    extend Forwardable

    def self.pack(container)
      new(container).pack
    end

    def initialize(container)
      @container = container
    end

    def_delegators :container, :new_packing!, :packings_limit, :packings, :packing

    def pack
      @items = container.items.sort_by!(&:volume).reverse!

      until too_many_packings?
        new_packing!
        pack_box(@items, container)
        return true if @items.empty?
      end
      false
    end

    private

    attr_reader :container

    def too_many_packings?
      packings.count >= packings_limit if packings_limit
    end

    def pack_box(possible_items, box)
      possible_items = possible_items.dup
      until possible_items.empty?
        item = possible_items.shift
        next unless item.rotate_to_fit_into(box)

        pack_item!(item, possible_items, box)
        break if possible_items.empty?

        box.sub_boxes(item).each do |sub_box|
          purge!(possible_items)
          pack_box(possible_items, sub_box)
        end
        break
      end
    end

    def pack_item!(item, possible_items, box)
      item.position = box.position
      possible_items.delete(item)
      packing << @items.delete(item)
    end

    def purge!(possible_items)
      possible_items.keep_if do |item|
        packing.fit?(item)
      end
    end
  end
end
