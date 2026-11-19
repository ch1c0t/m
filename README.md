# m

A Crystal CLI for selecting and executing Mitamae recipes.

## Build

```sh
bundle install
shards install
bundle exec rake
```

## Commands

```sh
m execute-mitamae-recipe
m execute-mitamae-recipe-at PATH
m list-mitamae-recipes
```

The interactive command sends the available paths to `fzf`. It lists
top-level `.rb` and `.list` files, directories up to two levels deep,
and `.rb` files at the second and third levels.

For root, the recipe directory is `~/recipes`. For other users,
`~/user.recipes` is used when it exists; otherwise `~/recipes` is used.
The selected path is executed with
`mitamae local --node-yaml ~/.config/recipes/node.yml PATH`. A directory
runs its `default.rb`; a `.list` file recursively executes each line as a
path relative to the recipe root.

The CLI requires `fzf` for interactive selection and `mitamae` to execute
recipes. It replaces the selection and execution logic of the original Zsh
function, but does not itself register a ZLE widget or key binding. A Zsh
widget can delegate to it:

```zsh
function execute-mitamae-recipe {
  m execute-mitamae-recipe
  zle accept-line
}
zle -N execute-mitamae-recipe
bindkey '\em' execute-mitamae-recipe
```
