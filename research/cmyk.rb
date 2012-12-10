require 'java'

# require './JpegReader.jar'
java_import com.sun.image.codec.jpeg.JPEGCodec
java_import com.sun.image.codec.jpeg.JPEGImageDecoder
java_import java.io.FileInputStream
java_import javax.imageio.ImageIO
java_import java.awt.image.BufferedImage
java_import java.awt.image.ColorConvertOp
java_import java.awt.color.ColorSpace
java_import java.awt.color.ICC_ColorSpace
java_import java.awt.color.ICC_Profile

JFile = java.io.File

path = '/Users/hcao/Downloads/broken.jpg'

jpeg_decoder = JPEGCodec.create_jpeg_decoder(FileInputStream.new(JFile.new(path)))
image = jpeg_decoder.decodeAsBufferedImage

image_raster = image.get_raster


rgb_image = BufferedImage.new(image.width, image.height, BufferedImage::TYPE_INT_RGB)
rgb_raster = rgb_image.get_raster

icc_profile_cmyk = ICC_Profile.getInstance(FileInputStream.new("ISOcoated_v2_300_eci.icc"));
color_space = ColorSpace.getInstance(ColorSpace::CS_sRGB);

(image_raster.get_min_x...image_raster.get_width).each do |x|
  (image_raster.get_min_y...image_raster.get_height).each do |y|
    pixel = image_raster.get_pixel(x, y, nil)
    pixel[3] = 255.0 - pixel[3]
    image_raster.set_pixel(x, y, pixel)
  end
end

# op = ColorConvertOp.new(ICC_ColorSpace.new(icc_profile_cmyk), color_space, nil);
op = ColorConvertOp.new(ICC_ColorSpace.new(icc_profile_cmyk), color_space, nil);
op.filter(image_raster, rgb_raster);

ImageIO.write(rgb_image, 'jpg', JFile.new('/Users/hcao/Downloads/xxx.jpg'))

# op = ColorConvertOp.new(nil)
# op.filter(image, rgb_image)
# ImageIO.write(rgb_image, 'jpg', JFile.new('/Users/hcao/Downloads/xxx.jpg'))


#  FOR AWT

# java_import java.awt.Toolkit
# java_import javax.imageio.ImageIO

# JFile = java.io.File

# java_import 'com.pressly.image.JpegReader'

# path = '/Users/hcao/Downloads/broken.jpg'
# # image = Toolkit.getDefaultToolkit().getImage(path);
# # new_image = image.getBufferedImage
# # ImageIO.write(new_image, 'jpg', JFile.new('/Users/hcao/Downloads/xxx1.jpg'))

# image = JpegReader.read_image(JFile.new(path))

# [ColorSpace::CS_CIEXYZ,
# ColorSpace::CS_GRAY,
# ColorSpace::CS_LINEAR_RGB,
# ColorSpace::CS_PYCC,
# ColorSpace::CS_sRGB,
# ColorSpace::TYPE_2CLR,
# ColorSpace::TYPE_3CLR,
# ColorSpace::TYPE_4CLR,
# ColorSpace::TYPE_5CLR,
# ColorSpace::TYPE_6CLR,
# ColorSpace::TYPE_7CLR,
# ColorSpace::TYPE_8CLR,
# ColorSpace::TYPE_9CLR,
# ColorSpace::TYPE_ACLR,
# ColorSpace::TYPE_BCLR,
# ColorSpace::TYPE_CCLR,
# ColorSpace::TYPE_CMY,
# ColorSpace::TYPE_CMYK,
# ColorSpace::TYPE_DCLR,
# ColorSpace::TYPE_ECLR,
# ColorSpace::TYPE_FCLR,
# ColorSpace::TYPE_GRAY,
# ColorSpace::TYPE_HLS,
# ColorSpace::TYPE_HSV,
# ColorSpace::TYPE_Lab,
# ColorSpace::TYPE_Luv,
# ColorSpace::TYPE_RGB,
# ColorSpace::TYPE_XYZ,
# ColorSpace::TYPE_YCbCr,
# ColorSpace::TYPE_Yxy]