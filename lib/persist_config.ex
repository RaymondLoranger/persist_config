defmodule PersistConfig do
  @moduledoc """
  Persists configuration files and puts the current app
  in module attribute @app (or in one of your choice).

  Option `:app_attr` identifies the module attribute where
  to put the current app.

  Option `:files` lists the configuration files to be persisted.
  Each entry represents a (wildcard) path relative to the root.
  If the list is or ends up being empty, no files are persisted.
  Of course, each individual configuration file must be imported.
  For example: `import_config "config/persist_this_config.exs"`.

  ## Options

    - `:app_attr` - module attribute for current app, defaults to `:app`
    - `:files`    - (wildcard) paths, defaults to `["config/persist*.exs"]`

  ## Usage

  ```elixir
  use PersistConfig files: ["config/persist_styles.exs"]
  @some_value Application.get_env(@app, :some_key)
  ```

  ```elixir
  use PersistConfig, app_attr: :my_app
  @my_value Application.get_env(@my_app, :my_key)
  ```
  """

  defmacro __using__(options \\ []) do
    app = options[:app_attr] || :app
    files = options[:files] || ["config/persist*.exs"]
    files = files |> Enum.map(&Path.wildcard/1) |> List.flatten()

    quote bind_quoted: [app: app, files: files] do
      Enum.each(files, fn file ->
        file |> Mix.Config.read!() |> Mix.Config.persist()
        @external_resource Path.expand(file)
      end)

      Module.put_attribute(__MODULE__, app, Mix.Project.config()[:app])
    end
  end
end
