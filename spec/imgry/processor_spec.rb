require 'spec_helper'

describe Imgry::Processor do

  let (:img_data) { IO.read(SPEC_ROOT.join('support/335is.jpg')) }

  context "a pretty picture" do    

    it "should do stuff..." do
      # This will use the best processor for the VM .. etc.
      # .. what about the format...?
      img = Imgry.with_bytes(img_data)

      # img.class # .. this will be ImageTools::Processor::MiniMagick or ::ImgScalr etc.

      # img.resize!("300x200!")

      # img = ImageTools.from_file(SPEC_ROOT.join('support/335is.jpg'))

      binding.pry
      x = 1
    end

  end

end
