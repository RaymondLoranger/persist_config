# PersistConfig

[![Build Status](https://travis-ci.org/RaymondLoranger/persist_config.svg?branch=master)](https://travis-ci.org/RaymondLoranger/persist_config)

Persists the configurations from a list of files during compilation.
Also puts the current application name in a module attribute and
provides a `get_env` macro for concise configuration value retrieval.

## Installation

Add `persist_config` to your list of dependencies in `mix.exs`. Also include
the required configuration files in the package definition of `mix.exs`:

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
    maintainers: [...],
    licenses: [...],
    links: %{...}
  ]
end
```

## Usage

`use PersistConfig` supports the following options:

- `:app`   - module attribute to hold the current application name,
             defaults to `:app`
- `:files` - wildcard paths, defaults to `["config/persist*.exs"]`

Option `:files` selects the files whose configurations will be persisted.
Each wildcard path is relative to the root. If no matching files are found,
no configurations are persisted.

Although it is __needless__ to do so, you can still import the configurations
from the above matching files in `config/config.exs` or friends. For example:

```elixir
import Config
import_config "persist_this_config.exs"
```

When your project is used as a dependency, this package will allow the
specified configuration files to have their configurations persisted during
compilation.

For example, you may configure some path to read an external file and want
to still read that __very__ file when your app is a dependency (without and
despite any path configuration in the parent app). To achieve this:

__1.__ Use a module attribute as a __constant__:

```elixir
use PersistConfig
...
@path get_env(:path)
```

__2.__ Create a configuration file named, say, `config/persist_path.exs`:

```elixir
import Config
config :words_cache, path: "#{File.cwd!()}/assets/words.txt"
```

__3.__ In `mix.exs`, specify a package definition like this:

```elixir
defp package do
  [
    files: [... "assets/words.txt", "config/persist*.exs"],
    maintainers: [...],
    licenses: [...],
    links: %{...}
  ]
end
```

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
