module M
  def self.execute_recipe_at(path : String, root : String, home : String) : Int32
    return run_mitamae(File.join(path, "default.rb"), home) if Dir.exists?(path)
    case File.extname(path)
    when ".rb"   then run_mitamae(path, home)
    when ".list" then execute_recipe_list(path, root, home)
    else 0
    end
  end
end
