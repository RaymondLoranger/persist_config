defmodule PersistConfigTest do
  use ExUnit.Case, async: true
  use PersistConfig, app: :this_app

  # doctest PersistConfig

  alias IO.ANSI

  @dummy_test1 get_env(:dummy_test1)

  test "@this_app is the current application" do
    assert @this_app == :persist_config
  end

  test "compile-time assignment" do
    assert @dummy_test1 == :dummy_test1
  end

  # `use PersistConfig` persists the configurations in `config/persist*.exs`.
  test "config persisted by `use PersistConfig`" do
    assert get_env(:dummy_test1) == :dummy_test1
    refute get_env(:dummy_test1) == DUMMY_TEST1
    assert get_env(:dummy_test2) == :dummy_test2
  end

  # `mix test` only loads the new configurations in `config/config.exs`.
  test "config loaded by `mix test`" do
    label = "#{ANSI.light_magenta()}\nall env of :persist_config#{ANSI.reset()}"
    syntax_colors = ANSI.syntax_colors()

    get_all_env(@this_app)
    |> IO.inspect(label: label, syntax_colors: syntax_colors, pretty: true)

    assert get_env(:speed_of_light_in_meters_per_second) == 299_792_458
  end

  # `runtime.exs` overrides `config/config.exs`.
  test "runtime config overrides build-time config" do
    assert get_env(:pi) == 3.14159265
  end
end
