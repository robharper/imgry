require 'spec_helper'

describe Imgry do

  let (:img_data) { IO.read(SPEC_ROOT.join('support/335is.jpg')) }

  context "a pretty picture" do    

    it "resizes an image from memory through high level interface" do
      img = Imgry.with_bytes(img_data)

      img.resize!("300x")
      img.width.should == 300
    end

    it "loads from a file and resizes an image" do
      img = Imgry.from_file(SPEC_ROOT.join('support/335is.png'))
      img.resize!("400x")
      img.width.should == 400
    end

    it "raises error if file is bogus" do
      expect { Imgry.from_file('hi') }.to raise_error(Imgry::FileUnreadableError)
    end

    it "writes to a file" do
      img = Imgry.with_bytes(img_data)
      tmpfile = Dir.tmpdir+'/imgry.jpg'
      img.save(tmpfile)
      File.exists?(tmpfile).should == true
      File.unlink(tmpfile)
    end

  end

end
