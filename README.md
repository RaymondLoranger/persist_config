# PersistConfig

[![Build Status](https://travis-ci.org/RaymondLoranger/persist_config.svg?branch=master)](https://travis-ci.org/RaymondLoranger/persist_config)

Persists, at compile time, a list of configuration files and
puts the current application name in a module attribute.

Also provides a `get_env` macro for concise configuration value retrieval.

## use PersistConfig

Supports the following options:

- `:app`   - module attribute to hold the current application name,
             defaults to `:app`
- `:files` - (wildcard) paths, defaults to `["config/persist*.exs"]`

Option `:files` lists the configuration files to be persisted.
These are typically imported in the `config/config.exs` file.
For example: `import_config "persist_this_config.exs"`.

Each entry represents a (wildcard) path relative to the root.
If the list is or ends up being empty, no files are persisted.

When your project is used as a dependency, this package will
allow the specified configuration files to be persisted.

For example, if you configured some path to read an external
file and want to still read that very file when your app is a
dependency (without any path configuration in the parent app).

## Usage

```elixir
use PersistConfig, files: ["config/persist_path.exs"]
...
@all_env Application.get_all_env(@app)
@path get_env(:path)
```

```elixir
use PersistConfig, app: :my_app
...
@my_attr Application.get_env(@my_app, :my_attr)
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
    {:persist_config, "~> 0.4"}
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
