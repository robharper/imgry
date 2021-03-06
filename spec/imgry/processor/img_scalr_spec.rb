require 'spec_helper'

if RUBY_ENGINE == 'jruby'
  describe Imgry::Processor::ImgScalr do

    let (:img_data) { IO.read(SPEC_ROOT.join('support/335is.jpg')) }
    let (:transparent_img_data) { IO.read(SPEC_ROOT.join('support/transparent_background.png')) }
    let (:broken_img_data) { IO.read(SPEC_ROOT.join('support/invalid_image.gif')) }

    context "broken_image_blob_data" do
      it "raises exception" do
        lambda { Imgry::Processor::ImgScalr.with_bytes(broken_img_data) }
          .should raise_error(Imgry::InvalidImageError)
      end
    end

    context "a pretty picture" do

      it "basic loading and resizing of an image" do
        img = Imgry::Processor::ImgScalr.with_bytes(img_data)

        img.width.should == 1024
        img.height.should == 764

        img.resize!("512x")
        img.width.should == 512
        img.height.should == 382

        new_img_blob = img.to_blob
        new_img_blob.length.should < img_data.length
        new_img_blob.length.should == 30319
      end

      it "crops an image" do
        img = Imgry::Processor::ImgScalr.with_bytes(img_data)

        img.width.should == 1024
        img.height.should == 764

        img.crop!("300x200+100+300")
        img.width.should == 300
        img.height.should == 200
      end

      it "handles offsets properly when cropping an image" do
        img = Imgry::Processor::ImgScalr.with_bytes(img_data)

        img.crop!("300x200+800+600")
        img.width.should == 224
        img.height.should == 164
      end

    end

    context "image format" do

      it "corrects passed in format" do
        img = Imgry::Processor::ImgScalr.with_bytes(img_data)
        img.format.should == 'jpg'
      end

      it "knows how to detect jpg files" do
        img = Imgry::Processor::ImgScalr.with_bytes(img_data)
        img.format.should == 'jpg'
      end

      it "knows how to detect png files" do
        img = Imgry::Processor::ImgScalr.with_bytes(transparent_img_data)
        img.format.should == 'png'
        img.save SPEC_ROOT.join('support/transparent_background_saved.png')
      end

    end

  end
end