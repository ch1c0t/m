module M
  def self.recipe_paths(root : String) : Array(String)
    raise "Recipe directory not found: #{root}" unless Dir.exists?(root)
    top = (Dir.glob("#{root}/*.rb") + Dir.glob("#{root}/*.list"))
      .select { |path| File.file?(path) }.sort
    dirs = (Dir.glob("#{root}/*") + Dir.glob("#{root}/*/*"))
      .select { |path| Dir.exists?(path) }.sort
    second = Dir.glob("#{root}/*/*.rb").select { |path| File.file?(path) }.sort
    third = Dir.glob("#{root}/*/*/*.rb").select { |path| File.file?(path) }.sort
    top + dirs + second + third
  end
end
