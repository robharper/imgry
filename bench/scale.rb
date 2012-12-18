$:.unshift File.join(File.dirname(__FILE__), "../lib")
require 'img_scalr_voodoo'

image_file = 'image_hires.jpg'

ImgScalrVoodoo.with_image(image_file) do |img|
  img.thumbnail(50) { |thumb|
    thumb.save("b_#{image_file}")
  }
end
