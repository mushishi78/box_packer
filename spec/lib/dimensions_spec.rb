module BoxPacker
	describe Dimensions do 
		subject(:dimensions){ Dimensions[2, 10, 3] }

		describe '#volume' do 
			it { expect(dimensions.volume).to eql(60) }
		end

		describe '#>=' do 

			context 'when compared with Dimensions that are all bigger' do 
				let(:other_dimensions) { Dimensions[1, 5, 2] }
				it { expect(dimensions >= other_dimensions).to be(true) }
			end

			context 'when compared with Dimensions where some are bigger and some are equal' do 
				let(:other_dimensions) { Dimensions[2, 5, 3] }
				it { expect(dimensions >= other_dimensions).to be(true) }
			end

			context 'when compared with Dimensions that are all equal' do 
				let(:other_dimensions) { Dimensions[2, 10, 3] }
				it { expect(dimensions >= other_dimensions).to be(true) }
			end

			context 'when compared with Dimensions where some are bigger and some are smaller' do 
				let(:other_dimensions) { Dimensions[5, 5, 1] }
				it { expect(dimensions >= other_dimensions).to be(false) }
			end

			context 'when compared with Dimensions where none are bigger' do 
				let(:other_dimensions) { Dimensions[5, 15, 11] }
				it { expect(dimensions >= other_dimensions).to be(false) }
			end

		end

		describe '#each_rotation' do 
			let(:rotations){[
				Dimensions[2, 10, 3], 
				Dimensions[2, 3, 10], 
				Dimensions[10, 2, 3], 
				Dimensions[10, 3, 2], 
				Dimensions[3, 10, 2], 
				Dimensions[3, 2, 10]
			]}

			it { expect{|b| dimensions.each_rotation(&b)}.to yield_each_once(rotations) }
		end

	end
end