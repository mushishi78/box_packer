require 'box_packer/container'

module BoxPacker
  describe Container do
    subject(:container) { Container.new([25, 30, 15]) }

    it { expect(container.packings).to eql(nil) }

    context 'with items' do
      let(:items) do
        [
          Item.new([15, 24, 8], weight: 25),
          Item.new([2,  1, 2], weight:  6),
          Item.new([9,  9, 10], weight: 30)
        ]
      end
      before { container.items = items }

      context 'with container prepared' do
        before do
          container.send(:prepare_to_pack!)
        end

        describe '#prepare_to_pack!' do
          let(:expected_dimensions)do
            [
              Dimensions[24, 15, 8],
              Dimensions[2, 2, 1],
              Dimensions[10, 9, 9]
            ]
          end

          it { expect(container.items.map(&:dimensions)).to eql(expected_dimensions) }
          it { expect(container.packings).to eql([]) }
        end

        context 'with some items packed' do
          before do
            container.new_packing!
            container.packing << items[1]
            container.packing << items[2]
          end

          it { expect(container.packings.length).to eql(1) }
          it { expect(container.packing).to match_array([items[1], items[2]]) }

          describe '#new_packing!!' do
            before { container.new_packing! }
            it { expect(container.packings.length).to eql(2) }
            it { expect(container.packing).to eql([]) }
          end
        end
      end

      describe '#packable?' do
        context 'with no items' do
          before { container.items = [] }
          it { expect(container.send(:packable?)).to be(false) }
        end

        context 'with items that fit' do
          it { expect(container.send(:packable?)).to be(true) }
        end

        context 'with an item to large' do
          before { container.items[0].dimensions = Dimensions[26, 34, 8] }
          it { expect(container.send(:packable?)).to be(false) }
        end

        context 'with a weight limit thats lighter than one of the items' do
          before { container.weight_limit = 24 }
          it { expect(container.send(:packable?)).to be(false) }
        end

        context 'with a packings limit of one packing' do
          before { container.packings_limit = 1 }

          context 'with a weight limit thats lighter than items' do
            before { container.weight_limit = 50 }
            it { expect(container.send(:packable?)).to be(false) }
          end

          context 'with a weight limit thats heavier than items' do
            before { container.weight_limit = 70 }
            it { expect(container.send(:packable?)).to be(true) }
          end
        end
      end
    end
  end
end
