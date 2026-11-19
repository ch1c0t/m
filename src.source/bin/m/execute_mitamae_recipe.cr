module M
  def self.execute_mitamae_recipe(root : String, home : String) : Int32
    selected = select_recipe(recipe_paths(root))
    selected ? execute_recipe_at(selected, root, home) : 0
  end
end
