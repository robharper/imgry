require 'spec_helper'

describe Imgry::Geometry do

  it 'scales to a strict size' do
    size = Imgry::Geometry.scale(300, 500, "70x70!")
    size.should == [70, 70]
  end

  it 'scales to a size with aspect ratio maintained' do
    size = Imgry::Geometry.scale(1024, 768, "600x")
    size.should == [600, 450]
  end

  it 'scales to a size with aspect ratio maintained' do
    size = Imgry::Geometry.scale(1024, 768, "x300")
    size.should == [400, 300]
  end

  it 'shrinks to a size when dimensions are larger then corresponding width/height' do
    size = Imgry::Geometry.scale(1024, 768, "600x600>")
    size.should == [600, 450]

    size = Imgry::Geometry.scale(300, 400, "600x600>")
    size.should == [300, 400]
  end

  it 'enlarges to a size when dimensions are smaller then corresponding width/height' do
    size = Imgry::Geometry.scale(1024, 768, "600x600<")
    size.should == [1024, 768]

    size = Imgry::Geometry.scale(300, 400, "600x600<")
    size.should == [600, 800]
  end

end
