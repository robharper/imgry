$:.unshift File.join(File.dirname(__FILE__), "../lib")
require 'img_scalr_voodoo'

image_file = 'image_hires.jpg'

ImgScalrVoodoo.with_image(image_file) do |img|
  img.resize(500, 500).save("l_#{image_file}")
  img.resize(150, 150).save("s_#{image_file}")
end
