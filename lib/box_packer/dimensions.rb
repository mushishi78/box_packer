require_relative 'vector'

module BoxPacker
  class Dimensions < Vector
    def volume
      @volume ||= to_a.reduce(&:*)
    end

    def >=(other)
      zip_map(other, :>=).reduce(&:&)
    end

    def each_rotation
      yield Dimensions[x, y, z]
      yield Dimensions[x, z, y]
      yield Dimensions[z, x, y]
      yield Dimensions[z, y, x]
      yield Dimensions[y, x, z]
      yield Dimensions[y, z, x]
    end

    def to_s
      to_a.join('x')
    end
  end
end
