require 'spec_helper'

describe Imgry do

  let (:img_data) { IO.read(SPEC_ROOT.join('support/335is.jpg')) }

  context "a pretty picture" do    

    it "should do stuff..." do
      img = Imgry.with_bytes(img_data)

      img.resize!("300x")
      img.width.should == 300
    end

  end

end
