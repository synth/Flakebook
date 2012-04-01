class FacebookAlbum
  attr_accessor :album, :photos
  def initialize(album_id, client)
    @client = client
    @album = Mogli::Album.find(album_id, client)
    @photos = @album.photos
  end
end