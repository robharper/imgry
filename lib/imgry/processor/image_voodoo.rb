module Imgry
  module Processor

    class ImageVoodoo < Adapter

      def self.load_lib!
        return if @lib_loaded

        if RUBY_ENGINE != 'jruby'
          raise 'The ImageVoodoo processor is only available on JRuby.'
        end

        begin
          require 'image_voodoo'
        rescue LoadError
          raise 'Cannot load image_voodoo gem.'
        end

        # TODO... 
        # turn on opengl........

        # Add-ons..
        ::ImageVoodoo.class_eval do
          def src
            @src
          end
        end

        @lib_loaded = true
      end

      #-----

      def load_image_blob!
        begin
          @image_ref = ::ImageVoodoo.with_bytes(@img_blob)
          if @image_ref.src.nil?
            raise InvalidImageError, "Image is either corrupt or unsupported."
          end
        rescue => ex
          raise InvalidImageError, ex.message
        end
      end

      def resize!(geometry)
        return if geometry.nil?        
        @image_ref = @image_ref.resize(*Geometry.scale(width, height, geometry))
      end

      def width
        @image_ref.width
      end

      def height
        @image_ref.height
      end

      def to_blob
        # TODO: output format is hardcoded, we should get the format
        # that it is while coming in, and use that on the way out..
        # we can use jpg by default..
        @image_ref.bytes('jpg')
      end

      def raw
        @image_ref
      end

      def supported_write_formats
        # Typical formats:
        # [BMP, bmp, jpg, JPG, wbmp, jpeg, png, JPEG, PNG, WBMP, GIF, gif]
        ::ImageVoodoo::ImageIO.getReaderFormatNames.to_a
      end

      def supported_read_formats
        # Typical formats:
        # [BMP, bmp, jpg, JPG, wbmp, jpeg, png, JPEG, PNG, WBMP, GIF, gif]
        ::ImageVoodoo::ImageIO.getWriterFormatNames.to_a
      end

      def clean!
        @image_ref = nil
        @src_blob = nil
      end

    end

  end
end

