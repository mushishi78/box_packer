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
      to_a.permutation.each { |perm| yield Dimensions[*perm] }
    end

    def to_s
      to_a.join('x')
    end
  end
end
