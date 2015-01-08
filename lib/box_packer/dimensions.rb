require 'matrix'

module BoxPacker
  class Dimensions < Vector
    def +(other)
      Dimensions[*super]
    end

    def -(other)
      Dimensions[*super]
    end

    def width
      Dimensions[self[0], 0, 0]
    end

    def height
      Dimensions[0, self[1], 0]
    end

    def depth
      Dimensions[0, 0, self[2]]
    end

    def volume
      @volume ||= self[0] * self[1] * self[2]
    end

    def >=(other)
      map2(other) { |v1, v2| v1 >= v2 }.reduce(&:&)
    end

    def each_rotation
      to_a.permutation.each do |perm|
        yield Dimensions[*perm]
      end
    end

    def to_s
      "#{self[0]}x#{self[1]}x#{self[2]}"
    end
  end
end
