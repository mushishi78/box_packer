require 'box_packer/item'

module BoxPacker
  describe Item do
    subject(:item) { Item.new(dimensions) }
    let(:dimensions) { [12, 5, 7] }

    describe '#rotate_to_fit_into' do
      context 'when box is larger than box' do
        let(:box) { Box.new(Dimensions[6, 15, 9]) }
        let(:rotated_dimensions) { Dimensions[5, 12, 7] }

        it 'fits and orientation is rotated to fit' do
          expect(item.rotate_to_fit_into(box)).to be(true)
          expect(item.dimensions).to eql(rotated_dimensions)
        end
      end

      context 'when other box has a smaller side than box' do
        let(:box) { Box.new(Dimensions[11, 6, 7]) }

        it 'does not fit and orientation is unchanged' do
          expect(item.rotate_to_fit_into(box)).to be(false)
          expect(item.dimensions).to eql(Dimensions[*dimensions])
        end
      end
    end
  end
end
