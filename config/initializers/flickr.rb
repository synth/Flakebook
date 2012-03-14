config_filepath = File.join(Rails.root, "config", "flickr.yml")
config = YAML.load(ERB.new(File.new(config_filepath).read).result)[Rails.env]

  
FlickRaw.api_key = config["api_key"]
FlickRaw.shared_secret = config["shared_secret"]
