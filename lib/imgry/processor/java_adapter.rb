module Imgry
  module Processor

    class JavaAdapter < Adapter

=begin
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
=end

    end

  end
end