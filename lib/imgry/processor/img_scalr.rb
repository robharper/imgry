module Imgry
  module Processor

    class ImgScalr < JavaAdapter
      require 'java/imgscalr-lib-4.2.jar'
      java_import org.imgscalr.Scalr

      def load_image!
        begin
          input_stream = ImageIO.create_image_input_stream(ByteArrayInputStream.new(@img_blob))
          detect_image_format!(input_stream)
          @img = ImageIO.read(input_stream)
        rescue => ex
          raise InvalidImageError, ex.message
        end
      end

      def src
        @img
      end

      def resize!(geometry)
        return if geometry.nil?
        new_width, new_height = Geometry.scale(width, height, geometry)

        @img = Scalr.resize(@img,
                            Scalr::Method::QUALITY,
                            Scalr::Mode::FIT_EXACT,
                            new_width, new_height,
                            Scalr::OP_ANTIALIAS)
      end

      def crop!(geometry)
        width, height, offset_x, offset_y, flag = crop_geometry(geometry)

        @img = Scalr.crop(@img, offset_x, offset_y, width, height)
      end

    end

  end
end
