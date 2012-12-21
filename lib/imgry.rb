module Imgry
  extend self

  attr_accessor :processor

  def with_bytes(img_blob)
    processor_klass.with_bytes(img_blob)
  end

  def from_file(path)
    processor_klass.from_file(path)
  end

  def processor_klass
    @processor_klass ||= begin
      k = processor.to_s.split('_').map {|x| x.capitalize }.join('')
      begin
        instance_eval("Imgry::Processor::#{k}")
      rescue
        raise "Unknown processor #{processor}"
      end
    end
  end

  def processor=(processor)
    @processor_klass = nil
    @processor = processor
  end

  class Error < StandardError
    def initialize(msg)
      super("#{self.class} #{msg}")
    end
  end

  class InvalidImageError < Error; end
  class UnsupportedFormatError < Error; end
  class FileUnreadableError < Error; end
  class FileUnwritableError < Error; end
end

Imagery = Imgry

if RUBY_ENGINE == 'jruby'
  Imgry.processor = :img_scalr
else
  Imgry.processor = :mini_magick
end

require 'imgry/version'
require 'imgry/geometry'
require 'imgry/processor'
