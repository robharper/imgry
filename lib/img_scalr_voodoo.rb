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

  def resize(width, height, options={})
    target = guard do
               Scalr.resize(@src,
                            Scalr::Method::QUALITY,
                            Scalr::Mode::FIT_EXACT,
                            width,
                            height,
                            Scalr::OP_ANTIALIAS)
             end

    image = ImgScalrVoodoo.new(target)

    block_given? ? yield(image) : image
  rescue NativeException => ne
    raise ArgumentError, ne.message
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