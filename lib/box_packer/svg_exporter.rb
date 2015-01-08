require 'rasem'

module BoxPacker
  class SVGExporter
    attr_private :container, :scale, :margin,
                 :images, :image, :image_width, :image_height

    def initialize(container, opts = {})
      @container = container
      @images = []
      @margin  = opts[:margin] || 10

      dimensions = container.dimensions.to_a
      longest_side = dimensions.max
      sides_total = dimensions.reduce(&:+)
      scale_longest_side_to = opts[:scale_longest_side_to] || 400

      @scale = scale_longest_side_to / longest_side.to_f
      @image_width = (longest_side * scale * 2) + (margin * 3)
      @image_height = (sides_total * scale) + (margin * 4)
    end

    def save(filename)
      images.each_with_index do |image, i|
        image.close

        File.open("#{filename}#{i + 1}.svg", 'w') do |f|
          f << image.output
        end
      end
    end

    def draw
      container.packings.each do |packing|
        Face.reset(margin, scale, container.dimensions)
        new_image
        6.times do
          face = Face.new(packing)
          image.rectangle(*face.outline, stroke: 'black', stroke_width: 1, fill: 'white')
          face.rectangles_and_labels.each do |h|
            image.rectangle(*h[:rectangle])
            image.text(*h[:label])
          end
        end
      end
    end

    private

    def new_image
      @image = Rasem::SVGImage.new(image_width, image_height)
      images << image
    end

    class Face
      attr_reader :width, :height, :axes
      attr_private :packing, :i, :j, :k, :front, :items
      attr_query :front?

      def self.reset(margin, scale, container_dimensions)
        @@coords_mapping = [0, 1, 2]
        @@front = true
        @@margin = margin
        @@axes = [margin, margin]
        @@scale = scale
        @@container_dimensions = container_dimensions
      end

      def iterate_class_variables
        if front?
          @@axes[0] = width + @@margin * 2
        else
          @@coords_mapping.rotate!
          @@axes[0] = @@margin
          @@axes[1] += height + @@margin
        end
        @@front = !@@front
      end

      def initialize(packing)
        @i, @j, @k = @@coords_mapping.dup
        @front = @@front
        @axes = @@axes.dup
        @width = @@container_dimensions[i] * @@scale
        @height = @@container_dimensions[j] * @@scale
        iterate_class_variables
        @items = sorted_items(packing)
      end

      def outline
        @axes + [width, height]
      end

      def rectangles_and_labels
        items.map do |item|
          x = axes[0] + item.position[i] * @@scale
          y = axes[1] + item.position[j] * @@scale
          width = item.dimensions[i] * @@scale
          height = item.dimensions[j] * @@scale
          label_x = x + width / 2 - item.label.length
          label_y = y + height / 2
          {
            rectangle: [x, y, width, height, fill: item.colour],
            label: [label_x, label_y, item.label]
          }
        end
      end

      private

      def sorted_items(packing)
        items = packing.sort_by { |i| i.position[k] }
        items.reverse! unless front?
        items
      end
    end
  end
end
