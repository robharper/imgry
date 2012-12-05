require 'spec_helper'

describe Imgry::Processor::ImageVoodoo do

  let (:img_data) { IO.read(SPEC_ROOT.join('support/335is.jpg')) }

  context "a pretty picture" do    

    it "basic loading and resizing of an image" do
      img = Imgry::Processor::ImageVoodoo.with_bytes(img_data)

      img.width.should == 1024
      img.height.should == 764

      img.resize!("512x")
      img.width.should == 512
      img.height.should == 382

      new_img_blob = img.to_blob
      new_img_blob.length.should < img_data.length
      new_img_blob.length.should == 32159
    end

  end

end