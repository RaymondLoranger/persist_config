# PersistConfig

Persists configuration files and puts the current app
in module attribute @app (or in one of your choice).

Option `:app_attr` identifies the module attribute where
to put the current app.

Option `:files` lists the configuration files to be persisted.
Each entry represents a (wildcard) path relative to the root.
If the list is or ends up being empty, no files are persisted.
Configuration files must be imported in the `config/config.exs`.
For example: `import_config "config/persist_this_config.exs"`.

When your project is used as a dependency, this package will
allow the specified configuration files to be persisted.

For example, if you configured some path to read an external
file and want to ensure you can still read that file even when
your app is a dependency.

However you must include the configuration files to be persisted
in the package definition of the `mix.exs` file as shown below.

```elixir
def project do
  [
    app: :your_app,
    ...
    package: package(),
    ...
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

## Installation

Add the `:persist_config` dependency to your `mix.exs` file:

```elixir
def deps() do
  [
    {:persist_config, "~> 0.2"}
  ]
end
```

## Options

- `:app_attr` - module attribute for current app, defaults to `:app`
- `:files`    - (wildcard) paths, defaults to `["config/persist*.exs"]`

## Usage

```elixir
use PersistConfig
@path Application.get_env(@app, :path)
...
{:ok, contents} = File.read(@path)
...
```

```elixir
use PersistConfig, app_attr: :my_app
@my_attr Application.get_env(@my_app, :my_attr)
```
