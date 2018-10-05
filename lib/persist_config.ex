defmodule PersistConfig do
  @moduledoc """
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
  """

  defmacro __using__(options \\ []) do
    app = options[:app] || :app
    files = options[:files] || ["config/persist*.exs"]
    files = files |> Enum.map(&Path.wildcard/1) |> List.flatten()

    quote bind_quoted: [app: app, files: files] do
      Enum.each(files, fn file ->
        file |> Mix.Config.eval!() |> elem(0) |> Mix.Config.persist()
        @external_resource Path.expand(file)
      end)

      Module.put_attribute(__MODULE__, app, Mix.Project.config()[:app])
    end
  end
end
