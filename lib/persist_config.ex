defmodule PersistConfig do
  @moduledoc """
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
