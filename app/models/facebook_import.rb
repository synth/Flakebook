class FacebookImport
  @queue = :file_serve
  def self.perform(access_token, flickr_username, photoset_id_string)
    client_manager = ClientManager.new_from_access_token(access_token, flickr_username)
    photoset_ids = photoset_id_string.split(",")

    sets = client_manager.get_flickr_sets_from_ids(photoset_ids)
    
    sets.each do |set|
      client_manager.transfer_flickr_set_to_facebook_album(set)
    end
    
  end
end