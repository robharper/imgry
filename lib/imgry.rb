module Imgry
  extend self

  def with_bytes(img_blob, format=nil)
  end

  def from_file(img_blob, format=nil)
  end

  def default_processor
    :mini_magick
  end

  def default_processor=(default_processor)
    @default_processor = default_processor
  end

end

Imagery = Imgry

require 'imgry/version'
require 'imgry/geometry'
require 'imgry/processor'
