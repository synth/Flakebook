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

    @sets = get_flickr_sets_from_ids(photoset_ids)
  end
  
  def confirm_import
    success = true
    @flickr_client = FlickrSync.new(:username => params[:flickr_user])
    
    @sets = get_flickr_sets_from_ids(params[:photoset_ids])
    
    @sets.each do |set|
      transfer_flickr_set_to_facebook_album(set)
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

  def get_photo_as_file_from_url(url)
    u = UrlUpload.new(url)
    f = u.file
    return f
  end
  
  def transfer_flickr_set_to_facebook_album(set)
    #determine if album exists with the same name
    unless album_id = album_exists?(set)
      #create album
      r = current_facebook_client.post("me/albums", nil, :name => set.title, :description => set.description)
      album_id = r["id"]
      
    end
    
    #get the photos
    photos = @flickr_client.get_photos_for_set(set)
    
    photos.each do |photo|
      #get photo as temp file from url
      f = get_photo_as_file_from_url(photo.url_o)
      
      #post photo
      r2 = current_facebook_client.post("/#{album_id}/photos", nil, {:source => f})
    end
  end
  
  
  def album_exists?(set)
    album_id = nil
    fb_albums = current_facebook_user.albums
    album = fb_albums.detect{|a| a.name == set.title}
    album_id = album.id if album
    return album_id
  end
  
  def get_flickr_sets_from_ids(photoset_ids)
    sets = []
    photoset_ids.each do |psid|
      sets << @flickr_client.get_set(psid)
    end
    return sets
  end
end
