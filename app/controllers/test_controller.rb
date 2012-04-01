class TestController < ApplicationController

  def index
    @imgs = Dir.glob("public/images/*")
    @imgs = @imgs.collect{|i| i.gsub("public/", "")}
    @reference_img = "/images/fpo-picture.gif"
    render :action => "index", :layout => false
  end
end
