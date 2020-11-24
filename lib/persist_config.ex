defmodule PersistConfig do
  @moduledoc ~S"""
  Persists, at compile time, a list of configuration files and
  puts the current application name in a module attribute.

  Also provides a `get_env` macro for concise configuration value retrieval.

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
  dependency (without any path configuration in the parent app):

  __1.__ Use a module attribute as a __constant__:

  ```elixir
  use PersistConfig
  ...
  @path get_env(:path)
  ```

  __2.__ Create a config file named, say, `config/persist_path.exs`:

  ```elixir
  import Config
  config :words_cache, path: "#{File.cwd!()}/words_cache/assets/words.txt"
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

  __Note:__ Such configurations must be truly __global__ and should otherwise be [avoided](https://hexdocs.pm/elixir/library-guidelines.html#avoid-application-configuration).

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
  """

  @doc """
  Persists, at compile time, a list of configuration files and
  puts the current application name in a module attribute.
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
  Returns the value for `key` in in the current application's environment.

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
