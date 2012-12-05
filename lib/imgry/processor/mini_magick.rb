module Imgry
  module Processor

    class MiniMagick < Adapter

      def self.load_lib!
        return if @lib_loaded

        begin
          require 'mini_magick'
        rescue LoadError
          raise "Cannot load mini_magick gem"
        end

        ::MiniMagick.processor = :gm
        ::MiniMagick.timeout = 45

        # Add-ons..
        ::MiniMagick::Image.class_eval do
          def run_command(command, *args)
            # -ping "efficiently determine image characteristics."
            if command == 'identify'
              args.unshift '-ping'

              # GraphicsMagick's identify has no -quiet option
              if ::MiniMagick.processor.to_s == 'gm'
                args.delete('-quiet')
              end
            end

            run(::MiniMagick::CommandBuilder.new(command, *args))
          end
        end

        @lib_loaded = true
      end

      #-----

      def load_image_blob!
        begin
          @image_ref = ::MiniMagick::Image.read(@img_blob)
        rescue ::MiniMagick::Invalid => ex
          raise InvalidImageError, ex.message
        end
      end

      def resize!(geometry)
        @image_ref.resize(geometry) if !geometry.nil?
        nil
      end

      def width
        @image_ref['width']
      end

      def height
        @image_ref['height']
      end

      def to_blob
        @image_ref.to_blob
      end

      def clean!
        @image_ref.destroy!
        @image_ref = nil
        @img_blob = nil
      end

    end

  end
end
