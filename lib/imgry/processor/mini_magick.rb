module Imgry
  module Processor

    class MiniMagick < Adapter

      def self.with_bytes(img_blob, format=nil)
        new(img_blob, format)
      end

      def self.from_file(path, format=nil)
        if !File.readable?(path)
          raise FileUnreadableError, path.to_s
        end

        new(IO.read(path), format)
      end

      def self.supported_formats
        # Hardcoded list of supported formats for validity checking..
        # Image/GraphicsMagick have a much more extensive list.
        # Submit an issue if this is a problem.
        ['bmp', 'jpg', 'wbmp', 'jpeg', 'gif', 'png', 'png32', 'png24', 'png8', 'tiff']
      end

      def load_image!
        begin
          @img = ::MiniMagick::Image.read(@img_blob)
        rescue ::MiniMagick::Invalid => ex
          raise InvalidImageError, ex.message
        end
      end

      def resize!(geometry)
        @img.resize(geometry) if !geometry.nil?
        nil
      end

      def width
        @img['width']
      end

      def height
        @img['height']
      end

      def format
        @img['format']
      end

      def to_blob
        @img.to_blob
      end

      def save(path)
        if !File.writable?(File.dirname(path))
          raise FileUnwritableError, path.to_s
        end
        if !self.class.supported_formats.include?(format.downcase)
          raise UnsupportedFormatError, format
        end
        @img.write(path.to_s)
      end

      def clean!
        @img.destroy!
        @img = nil
        @img_blob = nil
      end

    end

  end
end

#---

begin
  require 'mini_magick'

  MiniMagick.processor = :gm
  MiniMagick.timeout = 45

  # Fix.. this is in mini_magick's github master,
  # but not in the stable released gem
  class MiniMagick::Image
    def run_command(command, *args)
      # -ping "efficiently determine image characteristics."
      if command == 'identify'
        args.unshift '-ping'

        # GraphicsMagick's identify has no -quiet option
        if MiniMagick.processor.to_s == 'gm'
          args.delete('-quiet')
        end
      end

      run(MiniMagick::CommandBuilder.new(command, *args))
    end
  end
rescue LoadError
end
