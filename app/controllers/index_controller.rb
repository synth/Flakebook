class IndexController < ApplicationController
  before_filter :ensure_authenticated
  before_filter :ensure_flickr_user, :only => [:import_photos, :confirm_import]
  before_filter :init_flakebook

  def index
    #some flags for debugging/but also to make sure we have flickr user name
    @show_fb_albums = true
    @show_flickr_albums = false #set to false to ensure user specifies flickr user

    if @client_manager.flickr_client.has_user?
      
      albums = @client_manager.get_flickr_sets
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

    @sets = @client_manager.get_flickr_sets_from_ids(photoset_ids)
  end
  
  def confirm_import
    success = true
    
    @sets = @client_manager.get_flickr_sets_from_ids(params[:photoset_ids])
    
    @sets.each do |set|
      @client_manager.transfer_flickr_set_to_facebook_album(set)
    end
    
    
    ############
    #album_id = "3469598629711"
    
    # u = UrlUpload.new("http://p373.net/wp-content/uploads/upfw/p373-d.png")
    # f = u.file
    # r2 = current_facebook_client.post("/#{album_id}/photos", nil, {:source => f})

    
    
    if true#success
      flash[:notice] = "Albums successfully imported"
      redirect_to index_url
    end
  end
  
  protected
  def init_flakebook
    @client_manager = ClientManager.new(current_facebook_client, params[:flickr_user] )    
  end
  
  def ensure_flickr_user
    if params[:flickr_user].blank?
      flash[:notice] = "You missing a flickr user to import from"
      redirect_to index_url and return
    end     
  end
end
