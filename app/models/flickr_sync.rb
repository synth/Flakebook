class FlickrSync
  def initialize(opts={})
    @user = flickr.people.findByUsername(:username => opts[:username])
  end
  
  def get_sets
    sets = flickr.photosets.getList(:user_id => @user.id)
  end
  
  def get_photos_for_set(set)
    photos = flickr.photosets.getPhotos(:photoset_id => set.id, :extras => "url_o")
    photos = photos.photo
  end
end