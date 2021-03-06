class ClientManager
  attr_accessor :facebook_client, :flickr_client

  def initialize(_facebook_client, _flickr_username = nil)
    #we can pass in an app level facebook client or a lower level library client 
    #if the lower level client is passed in...pass it on to the high level client which knows what to do with it
    @facebook_client = _facebook_client.is_a?(FacebookClient) ? _facebook_client : FacebookClient.new(_facebook_client)
    @flickr_client = FlickrClient.new(:username => _flickr_username)
  end

  def self.new_from_access_token(access_token, flickr_username)
    fc = FacebookClient.new_from_access_token(access_token)
    self.new(fc, flickr_username)
  end
  
  def facebook_albums
    facebook_client.albums
  end
  
  def get_flickr_photoset_cover_photo(set)
    flickr_client.get_photo(set.primary, "thumbnail")
  end
  
  def get_facebook_album_cover_photo(album)
    facebook_client.get_album_cover_photo(album)
  end
  
  def get_flickr_sets
    flickr_client.get_sets
  end
  
  def get_photos_from_photoset(set)
    flickr_client.get_photos_for_set(set)
  end
  
  #This method is the meat/workhorse, whatever
  #it actually does the posting to facebook
  def transfer_flickr_set_to_facebook_album(set, opts = {})
    check_duplicates = opts[:skip_duplicates]
    Delayed::Worker.logger.info "Transferring photos to facebook from album: #{set.title}"

    #determine if album exists with the same name
    unless album = facebook_client.album_exists?(set.title)
      #create album
      album = facebook_client.create_album(set.title, set.description)      
    end
    fb_album = FacebookAlbum.new(album, facebook_client)
    
    #get the photos
    photos = flickr_client.get_photos_for_set(set)
    
    #loop through all the photos
    photos.each_with_index do |photo, index|
      # Rails.logger.debug "Posting photo to facebook with title: #{photo.title}"
      Delayed::Worker.logger.debug "Attempt #{index}/#{photos.length} transfers from flickr to facebook with title: #{photo.title}"
      Delayed::Worker.logger.debug " -----> flickr photo url: #{photo.url_o}"
      
      #get photo as temp file from url
      f = self.get_photo_as_file_from_url(photo.url_o)
      
      #post photo
      if check_duplicates
        # facebook_client.post_photo(album_id, f) unless facebook_client.has_same_photo?(album_id, f)
        facebook_client.post_photo(fb_album.id, f.file) unless facebook_client.has_same_photo?(fb_album.photos, f)
      else
        facebook_client.post_photo(fb_album.id, f.file)
      end
    end
  end
  
  def get_flickr_sets_from_ids(photoset_ids)
    sets = []
    photoset_ids.each do |psid|
      sets << flickr_client.get_set(psid)
    end
    return sets
  end  

  def get_photo_as_file_from_url(url)
    u = UrlUpload.new(url)
    f = u
#    f = u.file
    return f
  end  
end
