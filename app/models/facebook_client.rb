class FacebookClient
  attr_accessor :client, :user
  def initialize(_facebook_client)
    @client = _facebook_client
    @user = Mogli::User.find("me", @client)
  end
  
  def self.new_from_access_token(token)
    c = Mogli::Client.new(token)
    return self.new(c)
  end
  
  def albums
    user.albums
  end
  
  def get_album_cover_photo(album)
    cover_photo = Mogli::Photo.find(album.cover_photo, client) if album.cover_photo
  end

  def album_exists?(title)
    album_id = nil
    fb_albums = user.albums
    album = fb_albums.detect{|a| a.name == title}
    album_id = album.id if album
    return album_id
  end  
  
  def create_album(title, description)
    Rails.logger.debug "creating album: #{title} - #{description}"
    r = client.post("me/albums", nil, :name => title, :description => description)
    album_id = r["id"]
    return album_id
  end
  
  def post_photo(album_id, file)
    r2 = client.post("/#{album_id}/photos", nil, {:source => file})
  end
  
  #checks the album to see if there is a file with the same 
  def has_same_photo?(album_id, f)

    album = Mogli::Album.find(album_id, client)
    fb_photos = album.photos
    has_photo = false
    flickr_photo_digest = Digest::MD5.hexdigest(f.read)
    
    fb_photo_digest_set = []
    fb_photos.each do |p|
      fb_photo_url = p.picture
      fb_photo_file = get_photo_as_file_from_url(fb_photo_url)
      
      fb_photo_digest = Digest::MD5.hexdigest(fb_photo_file.read)
      fb_photo_digest_set << fb_photo_digest
      has_photo = true if fb_photo_digest == flickr_photo_digest
    end
    debugger
    return true
  end

  def get_photo_as_file_from_url(url)
    u = UrlUpload.new(url)
    f = u.file
    return f
  end 
    
  def method_missing(m, *args, &block)  
    self.client.send(m, *args)
  end
end