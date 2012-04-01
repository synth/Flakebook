require 'RMagick'
class ImageCompare
  attr_accessor :img1, :img2

  @@image_base = "/public/"

  def initialize(img1, img2)
    @img1 = img1
    @img2 = img2
  end
  
  def difference
    mimg1 = Magick::ImageList.new(Rails.root.to_s+@@image_base+@img1)
    mimg2 = Magick::ImageList.new(Rails.root.to_s+@@image_base+@img2)
    diff = mimg1.difference(mimg2.scale(mimg1.columns, mimg1.rows))
    #avg_diff = (diff[0]+diff[1]+diff[2])/3
    avg_diff = diff
    return avg_diff 
  end
  
  def same_image?
    return compare
  end
end
