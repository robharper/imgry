$:.unshift File.join(File.dirname(__FILE__), "../lib")
require 'imgry'
require 'benchmark'

image_file = 'image_hires.jpg'

max = (ARGV.shift || 100).to_i

IMAGE_SIZES = [
  {width: 1024, height: 1024, type: 'l'},
  {width: 615, height: 615, type: 'm'},
  {width: 300, height: 300, type: 's'},
  {width: 70, height: 70, type: 't'}
]

files = [image_file]
data = IO.read(image_file)

puts "Resizing image of #{data.bytesize} bytes #{max} times"

Benchmark::bm(20) do |x|

  bench = Proc.new do |processor|
    Imgry.processor = processor
    max.times do
      img = Imgry.with_bytes(data)

      IMAGE_SIZES.each do |size|
        img.resize!("#{size[:width]}x#{size[:height]}")
        img.to_blob
      end
    end
  end

  if RUBY_ENGINE == 'jruby'
    x.report("img_scalr resize") do
      bench.call(:img_scalr)
    end

    x.report("image_voodoo resize") do
      bench.call(:image_voodoo)
    end
  end

  x.report("mini_magick resize") do
    bench.call(:mini_magick)
  end

end
