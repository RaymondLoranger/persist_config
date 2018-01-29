# PersistConfig

Persists configuration files and puts the current app in a module attribute.

## use PersistConfig

Supports the following options:

- `:app`   - module attribute to hold the current app, defaults to `:app`
- `:files` - (wildcard) paths, defaults to `["config/persist*.exs"]`

Option `:files` lists the configuration files to be persisted.
These are typically imported in the `config/config.exs` file.
For example: `import_config "persist_this_config.exs"`.

Each entry represents a (wildcard) path relative to the root.
If the list is or ends up being empty, no files are persisted.

When your project is used as a dependency, this package will
allow the specified configuration files to be persisted.

For example, if you configured some path to read an external
file and want to still read that file when your app is a
dependency (without any path configuration in the parent app).

## Usage

```elixir
use PersistConfig files: ["config/persist_path.exs"]
...
@path Application.get_env(@app, :path)
```

```elixir
use PersistConfig, app :my_app
...
@my_attr Application.get_env(@my_app, :my_attr)
```

## Installation

Add the `:persist_config` dependency to your `mix.exs` file.
Also include the configuration files to be persisted in the package definition
of the `mix.exs` file as shown below.

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
def deps() do
  [
    {:persist_config, "~> 0.2"}
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

## Usage

```elixir
use PersistConfig files: ["config/persist_path.exs"]
...
@path Application.get_env(@app, :path)
```

```elixir
use PersistConfig, app :my_app
...
@my_attr Application.get_env(@my_app, :my_attr)
```