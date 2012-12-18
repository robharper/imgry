module Imgry
  module Processor

    class MiniMagick < Adapter

      def self.with_bytes(img_blob)
        new(img_blob)
      end

      def self.from_file(path)
        if !File.readable?(path)
          raise FileUnreadableError, path.to_s
        end

        new(IO.read(path))
      end

      def load_image!
        begin
          @img = ::MiniMagick::Image.read(@img_blob)
        rescue ::MiniMagick::Invalid => ex
          raise InvalidImageError, ex.message
        end
      end

      def resize!(geometry)
        return if geometry.nil?
        @img.resize(geometry)
        nil
      end

      def width
        @img['width']
      end

      def height
        @img['height']
      end

      def format
        format = @img['format']

        # Normalize..
        if !format.nil?
          format.downcase!
          format == 'jpeg' ? 'jpg' : format
        end
      end

      def to_blob(format=nil)
        # TODO: support other output format
        @img.to_blob
      end

      def save(path)
        if !File.writable?(File.dirname(path))
          raise FileUnwritableError, path.to_s
        end
        # TODO: error checking on write
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
