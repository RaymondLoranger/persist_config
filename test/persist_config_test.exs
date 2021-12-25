defmodule PersistConfigTest do
  use ExUnit.Case, async: true
  use PersistConfig

  # doctest PersistConfig

  @dummy_test1 get_env(:dummy_test1)
  @dummy_test2 get_env(:dummy_test2)

  test "@app is the current application" do
    assert @app == :persist_config
  end

  test "@external_resource" do
    assert @external_resource == [
             Path.expand("config/persist_dummy_test2.exs"),
             Path.expand("config/persist_dummy_test1.exs")
           ]
  end

  test "@dummy_test1" do
    assert @dummy_test1 == :absolutely
  end

  test "@dummy_test2" do
    assert @dummy_test2 == :absolutely_too
  end
end
