defmodule RuntimeCheck do
  # When running your application locally with iex -S mix or mix run,
  # `config/config.exs` is evaluated every time the application starts.

  use PersistConfig

  @dummy_test2 get_env(:dummy_test2)
  @speed_of_light :speed_of_light_in_meters_per_second
  @persist_config_all_env get_all_env(@app)

  # Confirms that `config/config.exs` is persisted at runtime.
  # To run in iex: mix run -e 'RuntimeCheck.check_env'
  def check_env do
    # Persisted at compile-time...
    IO.inspect(@dummy_test2, label: "@dummy_test2")

    # Persisted at runtime...
    get_env(@speed_of_light) |> IO.inspect(label: @speed_of_light)
    get_env(:pi) |> IO.inspect(label: :pi)

    # Not persisted at runtime...
    get_env(:dummy_test2) |> IO.inspect(label: :dummy_test2)
  end

  # To run in iex: mix run -e 'RuntimeCheck.check_all_env'
  def check_all_env do
    get_all_env(@app) |> IO.inspect(label: :persist_config_all_env)
    IO.inspect(@persist_config_all_env, label: "@persist_config_all_env")
  end
end
