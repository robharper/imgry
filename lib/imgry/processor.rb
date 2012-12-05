module Imgry
  module Processor

    class Adapter

      def self.with_bytes(img_blob, format=nil)
        new(img_blob, format)
      end

      def self.from_file(path, format=nil)
        # TODO: .. get the format from the filepath ... unless specified..
      end

      def self.lib_loaded?
        !!@lib_loaded
      end

      def initialize(img_blob, format=nil)
        self.class.load_lib! if !self.class.lib_loaded?

        @img_blob = img_blob
        @format = format
        load_image_blob!
      end

# .......
      # def resize!(geometry)
      # end

      # def width
      # end

      # def height
      # end

      # def to_blob(format=nil)
      # end

      # def reset!
      # end

    end

    class InvalidImageError < StandardError; end

  end
end

%w(
  image_voodoo
  img_scalr
  mini_magick
).each {|lib| require "imgry/processor/#{lib}" }
