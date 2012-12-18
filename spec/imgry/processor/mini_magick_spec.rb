require 'spec_helper'

describe Imgry::Processor::MiniMagick do

  let (:img_data) { IO.read(SPEC_ROOT.join('support/335is.jpg')) }

  context "a pretty picture" do    
    it "basic loading and resizing of an image" do
      img = Imgry::Processor::MiniMagick.with_bytes(img_data)

      img.width.should == 1024
      img.height.should == 764

      img.resize!("512x")
      img.width.should == 512
      img.height.should == 382

      new_img_blob = img.to_blob
      new_img_blob.length.should < img_data.length
      new_img_blob.length.should == 32671
    end
  end

  context "image format" do
    it "corrects passed in format" do
      img = Imgry::Processor::MiniMagick.with_bytes(img_data)
      img.format.should == 'jpg'
    end
  end

end
