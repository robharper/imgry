$:.unshift File.join(File.dirname(__FILE__), "../lib")
require 'img_scalr_voodoo'

image_file = 'image_hires.jpg'

ImgScalrVoodoo.with_image(image_file) do |img|
  img.with_crop(800, 400, 1200, 1000) do |img2|
    img2.save("c_#{image_file}")
  end
end
