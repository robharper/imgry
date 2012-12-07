module Imgry
  module Processor

    class ImgScalr < JavaAdapter
      require 'java/imgscalr-lib-4.2.jar'
      java_import org.imgscalr.Scalr

      def load_image!
        begin
          @img = ImageIO.read(@img_blob)
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

      def crop!
        # TODO
      end

    end

  end
end

__END__
class ImgScalrVoodoo
  include Java

  require 'java/imgscalr-lib-4.2.jar'

  java_import javax.imageio.ImageIO
  java_import org.imgscalr.Scalr
  java_import java.awt.image.BufferedImage

  JFile = java.io.File

  def initialize(src)
    @src = src
  end

  def self.with_image(path)
    raise ArgumentError, "file does not exist" unless File.file?(path)
    image = guard do
              buffered_image = ImageIO.read(JFile.new(path))
              buffered_image ? ImgScalrVoodoo.new(buffered_image) : nil
            end

    image && block_given? ? yield(image) : image
  end


  def self.with_bytes(bytes)
    bytes = bytes.to_java_bytes if String === bytes
    image = guard do
              ImgScalrVoodoo.new(ImageIO.read(ByteArrayInputStream.new(bytes)))
            end

    block_given? ? yield(image) : image
  end

  def img_scalr_resize(width, height, options={})
    method = options[:method]? options[:method] : Scalr::Method::QUALITY
    mode   = options[:mode]? options[:mode] : Scalr::Mode::FIT_EXACT
    ops    = options[:ops]? options[:ops] : Scalr::OP_ANTIALIAS

    target = guard { Scalr.resize(@src, method, mode, width, height, ops) }

    image = ImgScalrVoodoo.new(target)

    block_given? ? yield(image) : image
  rescue NativeException => ne
    raise ArgumentError, ne.message
  end

  def resize(width, height)
    image = img_scalr_resize(width, height)
    block_given? ? yield(image) : image
  end

  def cropped_thumbnail(size)
    l, t, r, b, half = 0, 0, width, height, (width - height).abs / 2
    l, r = half, half + height if width > height
    t, b = half, half + width if height > width

    target = with_crop(l, t, r, b).thumbnail(size)
    block_given? ? yield(target) : target
  end

  def save(file)
    format = File.extname(file)
    return false if format == ""
    format = format[1..-1].downcase
    guard { ImageIO.write(@src, format, JFile.new(file)) }
    true
  end

  def scale(ratio)
    new_width, new_height = (width * ratio).to_i, (height * ratio).to_i
    target = resize(new_width, new_height)
    block_given? ? yield(target) : target
  end

  def thumbnail(size)
    target = scale(size.to_f / (width > height ? width : height))
    block_given? ? yield(target) : target
  end

  def with_crop(left, top, right, bottom)
    image = guard { ImgScalrVoodoo.new(Scalr.crop(@src, left, top, right-left, bottom-top)) }
    block_given? ? yield(image) : image
  end

  def self.guard(&block)
    begin
      return block.call
    rescue NoMethodError => e
      "Unimplemented Feature: #{e}"
    end
  end

  def guard(&block)
    ImgScalrVoodoo.guard(&block)
  end

  def height
    @src.height
  end

  def width
    @src.width
  end

  def to_java
    @src
  end
end