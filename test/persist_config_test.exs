defmodule PersistConfigTest do
  use ExUnit.Case, async: true
  use PersistConfig, app: :this_app

  # doctest PersistConfig

  @dummy_test1 get_env(:dummy_test1)

  test "@this_app is the current application" do
    assert @this_app == :persist_config
  end

  test "@external_resource" do
    assert @external_resource == [
             Path.expand("config/persist_dummy_test2.exs"),
             Path.expand("config/persist_dummy_test1.exs")
           ]
  end

  test "compile-time assignment" do
    assert @dummy_test1 == :dummy_test1
  end

  # `use PersistConfig` persists the configurations in `config/persist*.exs`.
  test "config persisted by `use PersistConfig`" do
    assert get_env(:dummy_test2) == :dummy_test2
  end

  # `mix test` persists the configurations in `config/config.exs`.
  test "config persisted by `mix test`" do
    assert get_env(:speed_of_light_in_meters_per_second) == 299_792_458
  end

  # `runtime.exs` overrides `config/config.exs`.
  test "runtime config overrides build-time config" do
    assert get_env(:pi) == 3.14159265
  end
end
