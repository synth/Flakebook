class FacebookAlbum
  attr_accessor :album, :photos
  def initialize(album, client)
    @client = client
    # @album = Mogli::Album.find(album_id, client)
    @album = album
    @photos = @album.photos
  end
end