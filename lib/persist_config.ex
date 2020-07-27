defmodule PersistConfig do
  @moduledoc """
  Persists a list of configuration files and
  puts the current application name in a module attribute.

  Also includes macros for concise configuration value retrieval.

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

  ## Usage

  ```elixir
  use PersistConfig, files: ["config/persist_path.exs"]
  ...
  @all_env Application.get_all_env(@app)
  @path fetch_env!(:path)
  ```

  ```elixir
  use PersistConfig, app: :my_app
  ...
  @my_attr Application.fetch_env!(@my_app, :my_attr)
  ```
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
  Returns the value for `key` in `app`'s environment.

  If the configuration parameter does not exist, raises `ArgumentError`.
  """
  @doc since: "0.3.0"
  defmacro fetch_env!(app, key) do
    quote bind_quoted: [app: app, key: key] do
      Application.fetch_env!(app, key)
    end
  end

  @doc """
  Returns the value for `key` in the current application's environment.

  If the configuration parameter does not exist, raises `ArgumentError`.
  """
  @doc since: "0.3.0"
  defmacro fetch_env!(key) do
    app = Mix.Project.config()[:app]
    fetch_env!(app, key)
  end
end
