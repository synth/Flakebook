require 'RMagick'
class ImageCompare
  attr_accessor :img1, :img2

  @@image_base = "/public/"

  def initialize(img1, img2)
    @img1 = img1
    @img2 = img2
  end

# This method uses RMagick's difference method
#
#   It will return an array of three Float values, we'll use the 2nd one
# 
#     mean error per pixel
#       The mean error for any single pixel in the image.
#     
#     normalized mean error
#       The normalized mean quantization error for any single pixel in the image. This distance measure 
#       is normalized to a range between 0 and 1. It is 
#       independent of the range of red, green, and blue values in the image.
#
#     normalized maximum error
#       The normalized maximum quantization error for any single pixel in the image. This distance measure
#       is normalized to a range between 0 and 1. It is independent of the range of red, green, and blue values 
#       in your image.  
#
  def difference
    mimg1 = Magick::ImageList.new(Rails.root.to_s+@@image_base+@img1)
    mimg2 = Magick::ImageList.new(Rails.root.to_s+@@image_base+@img2)
    diff = mimg1.difference(mimg2.scale(mimg1.columns, mimg1.rows))
    #avg_diff = (diff[0]+diff[1]+diff[2])/3
    avg_diff = diff
    return avg_diff 
  end
  
  def identical?(opts = {})
    return difference[1] < (opts[:tolerance] || 0.02)
  end
end
