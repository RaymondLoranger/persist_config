defmodule PersistConfigCheck do
  @moduledoc false

  use PersistConfig

  @dummy_test1 get_env(:dummy_test1)
  @dummy_test2 get_env(:dummy_test2)
  @persist_config_all_env get_all_env(@app)
  @pi get_env(:pi)
  @c :speed_of_light_in_meters_per_second

  # Confirms that:
  # - `config/config.exs` is loaded at runtime
  # - `config/persist_dummy_test?.exs` is not loaded at runtime
  # - `config/runtimeexs` overrides `config/config.exs`
  # - etc.

  # To run => mix run -e 'PersistConfigCheck.check_env'
  @spec check_env :: :ok
  def check_env do
    puts("\n`config/persist_dummy_test?.exs` loaded at compile-time...")
    check(@dummy_test1, "@dummy_test1 (should be :dummy_test1)")
    check(@dummy_test2, "@dummy_test2 (should be :dummy_test2)")

    puts("\n`config/persist_dummy_test?.exs` not loaded at runtime...")
    get_env(:dummy_test1) |> check(":dummy_test1 (should be DUMMY_TEST1)")
    get_env(:dummy_test2) |> check(":dummy_test2 (should be nil)")

    puts("\n`config/config.exs` loaded at runtime...")
    get_env(@c) |> check("#{inspect(@c)} (should be 299792458)")

    puts("\n`config/runtime.exs` overrides `config/config.exs`...")
    check(@pi, "@pi (should be 3.1416)")
    get_env(:pi) |> check(":pi (should be 3.14159265)")

    :ok
  end

  # To run => mix run -e 'PersistConfigCheck.check_all_env'
  @spec check_all_env :: :ok
  def check_all_env do
    puts("\nCompile-time all env of :persist_config...")
    check(@persist_config_all_env, "@persist_config_all_env")

    puts("\nRuntime all env of :persist_config...")
    get_all_env(@app) |> check(:persist_config_all_env)
  end

  ## Private functions

  @spec puts(String.t()) :: :ok
  defp puts(msg) do
    IO.ANSI.format([:light_green, msg]) |> IO.puts()
  end

  @spec check(term, String.t() | atom) :: :ok
  defp check(value, label) do
    IO.inspect(value, label: label)
    :ok
  end
end
