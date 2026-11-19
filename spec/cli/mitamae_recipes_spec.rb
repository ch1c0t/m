require 'open3'
require 'tmpdir'
require 'fileutils'

RSpec.describe 'Mitamae recipe commands' do
  let(:home) { Dir.mktmpdir('m recipes ') }
  let(:root) { File.join(home, Process.uid.zero? ? 'recipes' : 'user.recipes') }
  let(:bin_dir) { File.join(home, 'bin') }
  let(:log) { File.join(home, 'mitamae.log') }

  before { FileUtils.mkdir_p([root, bin_dir]) }
  after { FileUtils.remove_entry(home) }

  def stub_command(name, body)
    path = File.join(bin_dir, name)
    File.write(path, "#!/bin/sh\n#{body}\n")
    File.chmod(0755, path)
  end

  def run_m(*args)
    env = { 'HOME' => home, 'PATH' => "#{bin_dir}:#{ENV.fetch('PATH')}", 'MITAMAE_LOG' => log }
    Open3.capture3(env, './bin/m', *args)
  end

  def mitamae_stub
    stub_command('mitamae', 'printf "%s\\n" "$@" >> "$MITAMAE_LOG"')
  end

  def expected_args(recipe)
    ['local', '--node-yaml', File.join(home, '.config/recipes/node.yml'), recipe]
  end

  it 'lists recipe files and directories in the script ordering' do
    FileUtils.mkdir_p("#{root}/first/inner/deep")
    %w[alpha.rb recipes.list ignored.txt first/second.rb first/inner/third.rb first/inner/deep/fourth.rb first/inner/ignored.list].each do |path|
      FileUtils.mkdir_p(File.dirname(File.join(root, path)))
      File.write(File.join(root, path), '')
    end
    stdout, _, status = run_m('list-mitamae-recipes')
    expect(status.exitstatus).to eq(0)
    expect(stdout.lines.map(&:chomp)).to eq([
      "#{root}/alpha.rb", "#{root}/recipes.list", "#{root}/first",
      "#{root}/first/inner", "#{root}/first/second.rb", "#{root}/first/inner/third.rb"
    ])
  end

  it 'runs a directory default recipe with the configured node YAML' do
    mitamae_stub
    FileUtils.mkdir_p("#{root}/cookbook")
    _, _, status = run_m('execute-mitamae-recipe-at', "#{root}/cookbook")
    expect(status.exitstatus).to eq(0)
    expect(File.readlines(log, chomp: true)).to eq(expected_args("#{root}/cookbook/default.rb"))
  end

  it 'recursively executes list entries relative to the recipe root' do
    mitamae_stub
    FileUtils.mkdir_p("#{root}/cookbook")
    File.write("#{root}/all.list", "cookbook\nnested.list\n")
    File.write("#{root}/nested.list", "single.rb\n")
    stdout, _, status = run_m('execute-mitamae-recipe-at', "#{root}/all.list")
    expect(status.exitstatus).to eq(0)
    expect(stdout).to include("Executing a list of recipes at #{root}/all.list:")
    expect(File.readlines(log, chomp: true)).to eq(
      expected_args("#{root}/cookbook/default.rb") + expected_args("#{root}/single.rb")
    )
  end

  it 'uses fzf to select and execute a recipe' do
    mitamae_stub
    stub_command('fzf', 'head -n 1')
    File.write("#{root}/selected.rb", '')
    _, _, status = run_m('execute-mitamae-recipe')
    expect(status.exitstatus).to eq(0)
    expect(File.readlines(log, chomp: true)).to eq(expected_args("#{root}/selected.rb"))
  end
end
