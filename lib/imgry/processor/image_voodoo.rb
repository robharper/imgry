module Imgry
  module Processor

    class ImageVoodoo < JavaAdapter
      def load_image!
        begin
          input_stream = ImageIO.create_image_input_stream(ByteArrayInputStream.new(@img_blob))
          detect_image_format!(input_stream)
          @img = ::ImageVoodoo.new(ImageIO.read(input_stream))
        rescue => ex
          raise InvalidImageError, ex.message
        end
      end

      def src
        @img.src
      end

      def resize!(geometry)
        return if geometry.nil?
        @img = @img.resize(*Geometry.scale(width, height, geometry))
      end

      def crop!(geometry)
        width, height, offset_x, offset_y, flag = crop_geometry(geometry)

        @img = @img.with_crop(offset_x, offset_y, offset_x + width, offset_y + height)
      end

    end

  end
end

#---

begin
  require 'image_voodoo'

  # Add-ons..
  class ImageVoodoo
    def src
      @src
    end
  end
rescue LoadError
end
