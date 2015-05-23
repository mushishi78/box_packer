require 'box_packer/box'

module BoxPacker
  describe Box do
    subject(:box) { Box.new(dimensions, position: position) }
    let(:dimensions) { Dimensions[25, 30, 10] }
    let(:position) { Position[10, 25, 5] }
    let(:item) { Item.new(Dimensions[5, 2, 1]) }

    context 'if no position is given' do
      let(:position) { nil }

      it 'defaults to origin position' do
        expect(box.position).to eql(Position[0, 0, 0])
      end
    end

    describe '#orient!' do
      before { box.orient! }
      it { expect(box.dimensions).to eql(Dimensions[30, 25, 10]) }
    end

    describe '#sub_boxes_args' do
      let(:expected_args) do
        [
          [Dimensions[20, 30, 10], position: Position[15, 25, 5]],
          [Dimensions[5, 28, 10],  position: Position[10, 27, 5]],
          [Dimensions[5, 2, 9],    position: Position[10, 25, 6]]
        ]
      end

      it 'calculates the correct dimensions and positions' do
        expect(box.send(:sub_boxes_args, item)).to eql(expected_args)
      end
    end

    describe '#sub_boxes' do
      it 'orders sub-boxes by volumes' do
        sub_boxes = box.sub_boxes(item)
        expect(sub_boxes[0].volume).to be >= (sub_boxes[1].volume)
        expect(sub_boxes[1].volume).to be >= (sub_boxes[2].volume)
      end

      context 'with an item that reaches a side' do
        let(:item) { Box.new(Dimensions[15, 2, 10]) }

        it 'only returns 2 sub-boxes' do
          sub_boxes = box.sub_boxes(item)
          expect(sub_boxes.length).to eql(2)
        end
      end
    end
  end
end
