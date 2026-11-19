module M
  def self.run_cli(args : Array(String)) : Int32
    home = home_directory
    root = recipes_directory(home, MitamaePOSIX.getuid)
    ENV["MITAMAE_PATH_TO_RECIPES"] = root
    case args.first?
    when "execute-mitamae-recipe"
      return 2 unless args.size == 1
      execute_mitamae_recipe(root, home)
    when "execute-mitamae-recipe-at"
      return 2 unless args.size == 2
      execute_recipe_at(args[1], root, home)
    when "list-mitamae-recipes"
      return 2 unless args.size == 1
      recipe_paths(root).each { |path| puts path }
      0
    else
      STDERR.puts "Usage: m execute-mitamae-recipe [PATH]"
      STDERR.puts "       m execute-mitamae-recipe-at PATH"
      STDERR.puts "       m list-mitamae-recipes"
      2
    end
  rescue error
    STDERR.puts "m: #{error.message}"
    1
  end
end
