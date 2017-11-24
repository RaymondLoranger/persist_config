# PersistConfig

Persists your configuration file and puts the app
in module attribute :app or in one of your choice.

When your project is used as a dependency, this
package will allow your config file to persist.
For example, if you configured some path to read
an external file and want to ensure you can still
read the file even when your app is a dependency.

However you must include file `config/config.exs`
in the package definition of your `mix.exs` file:

```elixir
def project() do
  [
    app: :your_app,
    ...
    package: package(),
    ...
  ]
end
...
defp package() do
  [
    files: ["lib", "mix.exs", "README*", "config/config.exs"],
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
    {:persist_config, "~> 0.1"}
  ]
end
```

## Usage

```elixir
use PersistConfig
@path Application.get_env(@app, :path)
...
{:ok, contents} = File.read(@path)
...
```

```elixir
use PersistConfig, app: :my_app
@my_attr Application.get_env(@my_app, :my_attr)
```
