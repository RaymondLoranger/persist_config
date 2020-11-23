# PersistConfig

[![Build Status](https://travis-ci.org/RaymondLoranger/persist_config.svg?branch=master)](https://travis-ci.org/RaymondLoranger/persist_config)

Persists, at compile time, a list of configuration files and
puts the current application name in a module attribute.

Also provides a `get_env` macro for concise configuration value retrieval.

## Usage

`use PersistConfig` supports the following options:

- `:app`   - module attribute to hold the current application name,
             defaults to `:app`
- `:files` - (wildcard) paths, defaults to `["config/persist*.exs"]`

Option `:files` lists the configuration files to be persisted.  
Though not needed, these can still be imported in file `config/config.exs`.  
For example: `import_config "persist_this_config.exs"`.

Each entry represents a (wildcard) path relative to the root.
If the list is or ends up being empty, no files are persisted.

When your project is used as a dependency, this package will
allow the specified configuration files to be persisted.

For example, you may configure some path to read an external
file and want to still read that very file when your app is a
dependency (without any path configuration in the parent app).

However, such configurations must truly be global and should otherwise be [avoided](https://hexdocs.pm/elixir/library-guidelines.html#avoid-application-configuration).

#### Example 1

```elixir
use PersistConfig, files: ["config/persist_path.exs"]
...
@all_env Application.get_all_env(@app)
@path get_env(:path)
```

#### Example 2

```elixir
use PersistConfig, app: :my_app
...
@my_attr Application.get_env(@my_app, :my_attr)
```

#### Example 3

```elixir
use PersistConfig
...
defp log?, do: get_env(:log?, true)
```

## Installation

Add `persist_config` to your list of dependencies in `mix.exs`.
Also include the configuration files to be persisted in the package definition
of `mix.exs` as shown below:

```elixir
def project do
  [
    app: :your_app,
    ...
    deps: deps(),
    package: package(),
    ...
  ]
end
...
def deps do
  [
    {:persist_config, "~> 0.4", runtime: false}
  ]
end
...
defp package do
  [
    files: ["lib", "mix.exs", "README*", "config/persist*.exs"],
    maintainers: ["***"],
    licenses: ["***"],
    links: %{...}
  ]
end
```
