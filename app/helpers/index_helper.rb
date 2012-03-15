module IndexHelper
  def get_flickr_cover_photo_for_set(set)
    @flickr_client.get_photo(set.primary, "thumbnail")
  end
  
  def get_facebook_cover_photo_for_album(album)
    cover_photo = Mogli::Photo.find(album.cover_photo, current_facebook_client)
  end
end
