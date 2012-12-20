module Imgry
  module Processor

    class Adapter
      def self.load_lib!
      end

      def self.with_bytes(img_bytes)
        # Abstract
      end

      def self.from_file(path)
        # Abstract
      end

      attr_accessor :img, :img_blob, :format

      def initialize(img_blob)
        @img_blob = img_blob
        @format = nil
        @img = nil
        load_image!
      end

      def inspect
        if @format
          "#<#{self.class} format: #{@format}>"
        else
          "#<#{self.class}>"
        end
      end

      def load_image!
        # Abstract
      end

      def aspect_ratio
        width.to_f / height.to_f
      end

    end

  end
end

#---

# JRuby processors
if RUBY_ENGINE == 'jruby'
  %w(
    java_adapter
    image_voodoo
    img_scalr
  ).each {|lib| require "imgry/processor/#{lib}" }
end

# Generic processors
%w(
  mini_magick
).each {|lib| require "imgry/processor/#{lib}" }
