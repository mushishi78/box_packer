require 'box_packer/packing'

module BoxPacker
  describe Packing do
    subject(:packing) { Packing.new(total_volume, total_weight) }
    let(:total_volume) { 200 }
    let(:total_weight) { 50 }
    let(:items) do
      [
        Item.new([2, 4, 1], weight: 5),
        Item.new([5, 2, 7], weight: 6),
        Item.new([8, 4, 2], weight: 3)
      ]
    end

    it 'defaults to empty' do
      expect(packing).to eql([])
    end

    describe '#<<' do
      before { items.each { |i| packing << i } }

      it { expect(packing.remaining_volume).to eql(58) }
      it { expect(packing.remaining_weight).to eql(36) }

      context 'with items that do not have weight' do
        let(:items) do
          [
            Item.new([2, 4, 1]),
            Item.new([5, 2, 7]),
            Item.new([8, 4, 2])
          ]
        end

        it { expect(packing.remaining_weight).to be(50) }
      end

      context 'with total_weight nil' do
        let(:total_weight) { nil }
        it { expect(packing.remaining_weight).to be(nil) }
      end
    end

    describe '#fit?' do
      before { items.each { |i| packing << i } }

      context 'with item that fits' do
        let(:item) { Item.new([1, 5, 5], weight: 5) }
        it { expect(packing.fit?(item)).to be(true) }
      end

      context 'with item thats already packed' do
        it { expect(packing.fit?(items[0])).to be(false) }
      end

      context 'with item thats too large' do
        let(:item) { Item.new([3, 5, 5], weight: 25) }
        it { expect(packing.fit?(item)).to be(false) }
      end

      context 'with item thats too heavy' do
        let(:item) { Item.new([1, 5, 5], weight: 45) }
        it { expect(packing.fit?(item)).to be(false) }
      end

      context 'with total_weight nil and item that fits' do
        let(:total_weight) { nil }
        let(:item) { Item.new([1, 5, 5], weight: 5) }
        it { expect(packing.fit?(item)).to be(true) }
      end

      context 'with item that has no weight but fits' do
        let(:item) { Item.new([1, 5, 5]) }
        it { expect(packing.fit?(item)).to be(true) }
      end
    end
  end
end
