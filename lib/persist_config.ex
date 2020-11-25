defmodule PersistConfig do
  @moduledoc ~S"""
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

  Even when your project is used as a dependency, this package will load and
  persist the configurations from the specified files during compilation.

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

  The current application name is in @app by default:

  ```elixir
  use PersistConfig, files: ["config/persist_path.exs"]
  ...
  @all_env Application.get_all_env(@app)
  @path get_env(:path)
  ```

  #### Example 2

  The current application name is in @my_app as an option:

  ```elixir
  use PersistConfig, app: :my_app
  ...
  @my_attr Application.get_env(@my_app, :my_attr)
  ```

  #### Example 3

  Macro `get_env` will retrieve configuration values at runtime
  when configuration is done by `config/config.exs` and friends.

  ```elixir
  use PersistConfig
  ...
  defp log?, do: get_env(:log?, true)
  ```
  """

  @doc """
  Persists the configurations from a list of files during compilation. Also puts
  the current application name in a module attribute.

  `use PersistConfig` supports the following options:

  - `:app`   - module attribute to hold the current application name,
  defaults to `:app`
  - `:files` - wildcard paths, defaults to `["config/persist*.exs"]`
  """
  defmacro __using__(options \\ []) do
    app = options[:app] || :app
    files = options[:files] || ["config/persist*.exs"]
    files = files |> Enum.map(&Path.wildcard/1) |> List.flatten()

    quote bind_quoted: [app: app, files: files], unquote: true do
      import unquote(__MODULE__)

      Enum.each(files, fn file ->
        file |> Config.Reader.read!() |> Application.put_all_env()
        @external_resource Path.expand(file)
      end)

      Module.put_attribute(__MODULE__, app, Mix.Project.config()[:app])
    end
  end

  @doc """
  Returns the value for `key` in the current application's environment.

  If the configuration parameter does not exist, returns the `default` value.
  """
  @doc since: "0.4.0"
  defmacro get_env(key, default \\ nil) do
    app = Mix.Project.config()[:app]

    quote bind_quoted: [app: app, key: key, default: default] do
      :application.get_env(app, key, default)
    end
  end
end
