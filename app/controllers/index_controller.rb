class IndexController < ApplicationController
  before_filter :ensure_authenticated
  
  def index
    #some flags for debugging/but also to make sure we have flickr user name
    @show_fb_albums = true
    @show_flickr_albums = false #set to false to ensure user specifies flickr user

    if params[:flickr_user]
      @flickr_client = FlickrSync.new(:username => params[:flickr_user])
      albums = @flickr_client.get_sets
      @flickr_sets = albums
      # @flickr_sets = {}
      # albums.each do |a|
      #   cover_photo = @flickr_client.get_photo(a.primary, "thumbnail")
      #   @flickr_sets[a.id] = {:id => a.id, :a => a, :cover_photo => cover_photo}
      # end
      @show_flickr_albums = true
    end
    
    if @show_fb_albums
      # albums = current_facebook_user.albums
      # @facebook_albums = albums

      # @facebook_albums = {}
      # albums.each do |a|
      #   cover_photo = Mogli::Photo.find(a.cover_photo, current_facebook_client)
      #   @facebook_albums[a.id]  = {:id => a.id, :a => a, :cover_photo => cover_photo}
      # end
    end
    

  end

  def import_photos
    if params[:photoset_ids].blank?
      flash[:notice] = "You did not select any albums to import"
      redirect_to index_url and return
    end 
    photoset_ids = params[:photoset_ids]
    @flickr_client = FlickrSync.new(:username => params[:flickr_user])

    @sets = []
    photoset_ids.each do |psid|
      @sets << @flickr_client.get_set(psid)
    end
  end
  
  def confirm_import
    success = true
    if success
      flash[:notice] = "Albums successfully imported"
      redirect_to index_url
    end
  end
end
