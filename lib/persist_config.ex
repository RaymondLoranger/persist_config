defmodule PersistConfig do
  @moduledoc """
  Persists your configuration file and puts the app
  in module attribute :app or in one of your choice.

  ## Usage

  ```elixir
  use PersistConfig
  @attr Application.get_env(@app, :attr)
  ```

  ```elixir
  use PersistConfig, app: :my_app
  @my_attr Application.get_env(@my_app, :my_attr)
  ```
  """

  defmacro __using__(options \\ []) do
    app = options[:app] || :app

    quote bind_quoted: [app: app] do
      Mix.Project.config()[:config_path]
      |> Mix.Config.read!()
      |> Mix.Config.persist()

      @external_resource Mix.Project.config()[:config_path] |> Path.expand()
      Module.put_attribute(__MODULE__, app, Mix.Project.config()[:app])
    end
  end
end
