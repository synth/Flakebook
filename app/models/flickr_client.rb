class FlickrClient
  def initialize(opts={})
    @user = flickr.people.findByUsername(:username => opts[:username]) if opts[:username]
  end
  
  def has_user?
    !@user.nil?
  end
  
  def get_sets
    sets = flickr.photosets.getList(:user_id => @user.id)
  end
  
  def get_set(set_id)
    flickr.photosets.getInfo(:photoset_id => set_id)
  end
  
  def get_photos_for_set(set)
    photos = flickr.photosets.getPhotos(:photoset_id => set.id, :extras => "description, url_o")
    photos = photos.photo
  end
  
  def get_photo(id, size = "Thumbnail")
    photo_sizes = flickr.photos.getSizes(:photo_id => id)
    photo = photo_sizes.detect{|p| p.label == size.camelcase}
    return photo
  end
end