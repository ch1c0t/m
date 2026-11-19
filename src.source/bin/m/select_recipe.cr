module M
  def self.select_recipe(paths : Array(String)) : String?
    return nil if paths.empty?
    output = IO::Memory.new
    input = IO::Memory.new(paths.join("\n") + "\n")
    status = Process.run(["fzf"], input: input, output: output, error: STDERR)
    return nil if [1, 130].includes?(status.exit_code)
    raise "fzf exited with #{status.exit_code}" unless status.success?
    selected = output.to_s
    selected = selected[0...-1] if selected.ends_with?("\n")
    selected.empty? ? nil : selected
  end
end
