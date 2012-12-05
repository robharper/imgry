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
        op = geometry[-1] # Expecting !, >, <, or nothing
        new_width, new_height = nil, nil
        ask_width, ask_height = geometry.split('x').map {|x| x.to_i }
        ask_height ||= 0
        
        scale = Proc.new do
          if ask_width == 0 || ask_width < ask_height
            new_width, new_height = scale_by_height(ask_height)
          else
            new_width, new_height = scale_by_width(ask_width)
          end
        end

        case op
        when '!'
          new_width, new_height = ask_width.to_i, ask_height.to_i
        when '>'
          scale.call if width > ask_width || height > ask_height
        when '<'
          scale.call if width < ask_width || height < ask_height
        else
          scale.call
        end

        # In the end, we've determined we don't want to resizie (perhaps due to > or < operations)
        return if new_width.nil? || new_width.nil?

        # Resize .. do itttttttt
        @image_ref = @image_ref.resize(new_width, new_height)
      end

      def width
        @image_ref.width
      end

      def height
        @image_ref.height
      end

      def aspect_ratio
        width.to_f / height.to_f
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

      private

        def scale_by_width(new_width)
          [new_width.to_i, (new_width / aspect_ratio).to_i]
        end

        def scale_by_height(new_height)
          [(new_height * aspect_ratio).to_i, new_height.to_i]
        end

    end

  end
end

