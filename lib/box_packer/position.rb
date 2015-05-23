require_relative 'vector'

module BoxPacker
  class Position < Vector
    def to_s
      "(#{to_a.join(',')})"
    end
  end
end
