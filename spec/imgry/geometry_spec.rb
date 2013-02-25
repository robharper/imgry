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

  it 'fits given maximum dimensions with aspect ratio maintained when image aspect > 1' do
    size = Imgry::Geometry.scale(1024, 768, "300x600")
    size.should == [300, 225]

    size = Imgry::Geometry.scale(1024, 768, "600x300")
    size.should == [400, 300]
  end

  it 'fits given maximum dimensions with aspect ratio maintained when image aspect < 1' do
    size = Imgry::Geometry.scale(768, 1024, "300x600")
    size.should == [300, 400]

    size = Imgry::Geometry.scale(768, 1024, "600x300")
    size.should == [225, 300]
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
    size.should == [450, 600]
  end

  context "#from_s" do
    it 'handles geometry format: WxH+X+Y>' do
      geometry_str = "200x300+10+20!"
      width, height, offset_x, offset_y, flag = Imgry::Geometry.from_s(geometry_str)

      width.should    == 200
      height.should   == 300
      offset_x.should == 10
      offset_y.should == 20
      flag.should     == '!'
    end

    it 'handles geometry format: Wx>' do
      geometry_str = "200x"
      width, height, offset_x, offset_y, flag = Imgry::Geometry.from_s(geometry_str)

      width.should    == 200
      height.should   == 0
      offset_x.should == 0
      offset_y.should == 0
      flag.should     == ''
    end

    it 'handles geometry format: WxH>' do
      geometry_str = "200x300"
      width, height, offset_x, offset_y, flag = Imgry::Geometry.from_s(geometry_str)

      width.should    == 200
      height.should   == 300
      offset_x.should == 0
      offset_y.should == 0
      flag.should     == ''
    end

    it 'handles geometry format: WxH>' do
      geometry_str = "200x300>"
      width, height, offset_x, offset_y, flag = Imgry::Geometry.from_s(geometry_str)

      width.should    == 200
      height.should   == 300
      offset_x.should == 0
      offset_y.should == 0
      flag.should     == '>'
    end

    it 'handles geometry format: WxH+X' do
      geometry_str = "200x300+10"
      width, height, offset_x, offset_y, flag = Imgry::Geometry.from_s(geometry_str)

      width.should    == 200
      height.should   == 300
      offset_x.should == 10
      offset_y.should == 0
      flag.should     == ''
    end

    it 'handles geometry format: WxH+X>' do
      geometry_str = "200x300+10>"
      width, height, offset_x, offset_y, flag = Imgry::Geometry.from_s(geometry_str)

      width.should    == 200
      height.should   == 300
      offset_x.should == 10
      offset_y.should == 0
      flag.should     == '>'
    end
  end
end
