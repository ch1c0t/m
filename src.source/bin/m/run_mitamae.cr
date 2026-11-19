module M
  def self.run_mitamae(recipe : String, home : String) : Int32
    node = File.join(home, ".config", "recipes", "node.yml")
    args = ["mitamae", "local", "--node-yaml", node, recipe]
    Process.run(args, input: STDIN, output: STDOUT, error: STDERR).exit_code
  end
end
