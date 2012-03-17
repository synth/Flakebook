class ClientManager
  attr_accessor :facebook_client, :flickr_client

  def initialize(_facebook_client, _flickr_username = nil)
    @facebook_client = FacebookClient.new(_facebook_client)
    @flickr_client = FlickrClient.new(:username => _flickr_username)
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
  def transfer_flickr_set_to_facebook_album(set)

    #determine if album exists with the same name
    unless album_id = facebook_client.album_exists?(set.title)
      #create album
      album_id = facebook_client.create_album(set.title, set.description)      
    end
    
    #get the photos
    photos = flickr_client.get_photos_for_set(set)
    
    #loop through all the photos
    photos.each do |photo|

      #get photo as temp file from url
      f = self.get_photo_as_file_from_url(photo.url_o)
      
      #post photo
      facebook_client.post_photo(album_id, f)
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
    f = u.file
    return f
  end  
end