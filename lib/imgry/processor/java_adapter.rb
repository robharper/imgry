module Imgry
  module Processor

    class JavaAdapter < Adapter
      include Java

      java_import javax.imageio.ImageIO
      java_import java.awt.image.BufferedImage
      java_import java.io.ByteArrayInputStream
      java_import java.io.ByteArrayOutputStream

      # Turn on OpenGL .. benchmarks show that with or without
      # GPU performance is improved
      java.lang.System.setProperty('sun.java2d.opengl', 'true')

      def self.with_bytes(img_blob)
        bytes = img_blob.to_java_bytes if img_blob.is_a?(String)
        image_input_stream = ImageIO.create_image_input_stream(ByteArrayInputStream.new(bytes))

        new(image_input_stream)
      end

      def self.from_file(path)
        if !File.readable?(path)
          raise FileUnreadableError, path.to_s
        end

        img_blob = IO.read(path.to_s)
        with_bytes(img_blob)

        # TODO: read the file using Java file io instead..?
        # input_stream = java.io.FileInputStream.new(java.io.File.new(path.to_s))
      end

      def detect_image_format!(image_input_stream)
        if (reader = ImageIO.get_image_readers(image_input_stream).first)
          @format = reader.format_name.downcase
          @format = 'jpg' if @format == 'jpeg' # prefer this way..
        end
      end

      def self.supported_formats
        @supported_formats ||= begin
          # NOTE: assuming read and write formats are the same..
          # Typical formats: bmp, jpg, wbmp, jpeg, png, gif
          ImageIO.getReaderFormatNames.to_a.map(&:downcase).uniq
        end
      end

      def format
        @format
      end

      def width
        @img.width
      end

      def height
        @img.height
      end

      def clean!
        @img = nil
        @img_blob = nil
      end

      def crop_geometry(geometry)
        # no gravity support yet, so all offsets should be > 0
        width, height, offset_x, offset_y, flag = Geometry.from_s(geometry)

        offset_x = 0 if offset_x > self.width || offset_x < 0
        offset_y = 0 if offset_y > self.height || offset_y < 0

        width  = self.width - offset_x if width + offset_x > self.width
        height = self.height - offset_y if height + offset_y > self.height

        [width, height, offset_x, offset_y, flag]
      end

      def to_blob(format=nil)
        format ||= @format

        if !self.class.supported_formats.include?(format.downcase)
          raise UnsupportedFormatError, format
        end

        out = ByteArrayOutputStream.new
        ImageIO.write(src, format, out)
        String.from_java_bytes(out.to_byte_array)
      end

      def save(path)
        if !File.writable?(File.dirname(path))
          raise FileUnwritableError, path.to_s
        end

        ext = File.extname(path)
        format = !ext.nil? ? ext[1..-1].downcase : @format

        if !self.class.supported_formats.include?(format)
          raise UnsupportedFormatError, format
        end

        ImageIO.write(src, format.downcase, java.io.File.new(path.to_s))
        true
      end

    end

  end
end
