require 'box_packer'
require 'pry'
describe '.pack' do
  it do
    packings = BoxPacker.pack(
      container: { dimensions: [15, 20, 13], weight_limit: 50 },
      items: [
        { dimensions: [2, 3, 5], weight: 47 },
        { dimensions: [2, 3, 5], weight: 47 },
        { dimensions: [3, 3, 1], weight: 24 },
        { dimensions: [1, 1, 4], weight: 7 },
      ],
      opts: { preserve_order: true}
    )

    expect(packings.length).to eql(3)
    expect(packings[0][:weight]).to eql(47.0)
    expect(packings[0][:placements].length).to eql(1)
    expect(packings[0][:placements][0][:dimensions]).to eql([5, 3, 2])
    expect(packings[0][:placements][0][:position]).to eql([0, 0, 0])
    expect(packings[1][:weight]).to eql(47.0)
    expect(packings[1][:placements].length).to eql(1)
    expect(packings[1][:placements][0][:dimensions]).to eql([5, 3, 2])
    expect(packings[1][:placements][0][:position]).to eql([0, 0, 0])
    expect(packings[2][:weight]).to eql(31.0)
    expect(packings[2][:placements].length).to eql(2)
    expect(packings[2][:placements][0][:dimensions]).to eql([3, 3, 1])
    expect(packings[2][:placements][0][:position]).to eql([0, 0, 0])
    expect(packings[2][:placements][1][:dimensions]).to eql([4, 1, 1])
    expect(packings[2][:placements][1][:position]).to eql([3, 0, 0])
  end

  it 'no weight given' do
     packings = BoxPacker.pack(
      container: { dimensions: [13, 15, 20] },
      items: [
        { dimensions: [2, 3, 5] },
        { dimensions: [2, 3, 5] },
        { dimensions: [3, 3, 1] },
        { dimensions: [1, 1, 4] },
      ]
    )
    expect(packings.length).to eql(1)
    expect(packings[0][:weight]).to eql(0.0)
    expect(packings[0][:placements].length).to eql(4)
  end

  it 'should have same packings result' do
    packings = BoxPacker.pack(
      container: { dimensions: [60, 20, 7], weight_limit: 50 },
      items: [
        { dimensions: [20, 10, 1], weight: 1 },
        { dimensions: [50, 20, 5], weight: 1 },
        { dimensions: [60, 20, 1], weight: 1 }
      ]
    )
    expect(packings.length).to eql(1)
    expect(packings[0][:placements].length).to eql(3)
    expect(packings[0][:placements][0][:dimensions]).to eql([60, 20, 1])
    expect(packings[0][:placements][0][:position]).to eql([0, 0, 0])
    expect(packings[0][:placements][1][:dimensions]).to eql([50, 20, 5])
    expect(packings[0][:placements][1][:position]).to eql([0, 0, 1])
  end

  it 'apply user defined order' do
    packings = BoxPacker.pack(
      container: { dimensions: [60, 20, 7], weight_limit: 50 },
      items: [
        { dimensions: [20, 10, 1], weight: 1 },
        { dimensions: [50, 20, 5], weight: 1 },
        { dimensions: [60, 20, 1], weight: 1 }
      ],
      opts: {
        preserve_order: true
      }
    )
    expect(packings.length).to eql(3)
  end
end
