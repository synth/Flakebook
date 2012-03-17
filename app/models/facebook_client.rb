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
    fb_albums = client.albums
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
    r2 = client.post("/#{album_id}/photos", nil, {:source => f})
  end
end