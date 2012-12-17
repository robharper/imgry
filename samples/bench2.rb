require 'benchmark'

class ImageBench
  include Java

  DEFAULT_OUTPUT_FORMAT = 'jpg'

  java_import javax.imageio.ImageIO
  java_import java.awt.image.BufferedImage
  java_import java.io.ByteArrayInputStream
  java_import java.io.ByteArrayOutputStream

  java.lang.System.setProperty('sun.java2d.opengl', 'true')

  def self.with_bytes(img_blob, format=nil)
    bytes = img_blob.to_java_bytes if img_blob.is_a?(String)
    image_input_stream = ImageIO.create_image_input_stream(ByteArrayInputStream.new(bytes))
    out_format = detect_format(image_input_stream)
    ImageIO.read(image_input_stream)
  end


  def self.detect_format(image_input_stream)
    reader = ImageIO.get_image_readers(image_input_stream).first

    return DEFAULT_OUTPUT_FORMAT if reader.nil?

    reader.format_name.downcase
  end

  def self.with_bytes_without_format_detect(img_blob)
    bytes = img_blob.to_java_bytes if img_blob.is_a?(String)
    ImageIO.read(ByteArrayInputStream.new(bytes))
  end

end


bytes = IO.read('/Users/hcao/Development/gems/imgry/spec/support/335is.jpg')

Total = 100

Benchmark::bmbm(20) do |x|
  x.report("with_format_detect") do
    Total.times do
      ImageBench.with_bytes(bytes)
    end
  end

  x.report("without_format_detect") do
    Total.times do
      ImageBench.with_bytes_without_format_detect(bytes)
    end
  end
end