require 'spec_helper'

if RUBY_ENGINE == 'jruby'
  describe Imgry::Processor::ImgScalr do

    let (:img_data) { IO.read(SPEC_ROOT.join('support/335is.jpg')) }
    let (:transparent_img_data) { IO.read(SPEC_ROOT.join('support/transparent_background.png')) }

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

    end

    context "image format" do

      it "corrects passed in format" do
        img = Imgry::Processor::ImgScalr.with_bytes(img_data, 'gif')
        img.format.should == 'jpeg'
      end

      it "knows how to detect jpg files" do
        img = Imgry::Processor::ImgScalr.with_bytes(img_data)
        img.format.should == 'jpeg'
      end

      it "knows how to detect png files" do
        img = Imgry::Processor::ImgScalr.with_bytes(transparent_img_data)
        img.format.should == 'png'
        img.save SPEC_ROOT.join('support/transparent_background_saved.png')
      end

    end

  end
end