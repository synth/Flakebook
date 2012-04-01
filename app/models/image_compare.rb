class ImageCompare
  attr_accessor :img1, :img2

  @@image_base = "/public"

  def initialize(img1, img2)
    @img1 = img1
    @img2 = img2
  end
  
  def difference
    debugger
    mimg1 = Magick::ImageList.new(Rails.root.to_s+@@image_base+@img1)
    mimg2 = Magick::ImageList.new(Rails.root.to_s+@@image_base+@img2)
    diff = mimg1.difference(ming2)
    avg_diff = (diff[0]+diff[1]+diff[2])/3
    return true
  end
  
  def same_image?
    return compare
  end
end