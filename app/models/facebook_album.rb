class FacebookAlbum
  attr_accessor :album, :photos, :id
  def initialize(album, client)
    @client = client
    # @album = Mogli::Album.find(album_id, client)
    @album = album
    @photos = @album.photos
    @id = @album.id
  end
  
end