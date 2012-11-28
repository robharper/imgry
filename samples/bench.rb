$:.unshift File.join(File.dirname(__FILE__), "../lib")
require 'img_scalr_voodoo'
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

Benchmark::bm(20) do |x|
  x.report("resize") do
    files.each do |file|
      p "Processing #{file} ..."
      ImgScalrVoodoo.with_image(file) do |img|
        for i in 0..max do
          IMAGE_SIZES.each do |size|
            img.resize(size[:width], size[:height]).save("#{size[:type]}_#{file}")
          end
        end
      end
    end
  end
end