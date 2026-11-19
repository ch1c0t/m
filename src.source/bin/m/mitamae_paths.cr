@[Link("c")]
lib MitamaePOSIX
  fun getuid : UInt32
end

module M
  def self.home_directory : String
    ENV["HOME"]? || raise "HOME is not set"
  end

  def self.recipes_directory(home : String, uid : UInt32) : String
    recipes = File.expand_path(File.join(home, "recipes"))
    user = File.expand_path(File.join(home, "user.recipes"))
    uid == 0 || !Dir.exists?(user) ? recipes : user
  end
end
