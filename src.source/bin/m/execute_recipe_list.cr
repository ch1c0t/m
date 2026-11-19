module M
  def self.execute_recipe_list(path : String, root : String, home : String) : Int32
    lines = File.read(path).each_line.to_a
    puts "Executing a list of recipes at #{path}:"
    lines.each { |line| puts "    #{line}" }
    status = 0
    lines.each do |line|
      status = execute_recipe_at(File.join(root, line), root, home)
    end
    status
  end
end
