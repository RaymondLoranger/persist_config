defmodule PersistConfigTest do
  use ExUnit.Case, async: true
  use PersistConfig

  # doctest PersistConfig

  @dummy_test1 get_env(:dummy_test1)
  @dummy_test2 get_env(:dummy_test2)
  @app_dummy_test1 get_app_env(@app, :dummy_test1)
  @app_dummy_test2 get_app_env(@app, :dummy_test2)
  @all_logger_env get_all_env(:logger)
  @all_what_env get_all_env(:what)

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
    assert @dummy_test1 == @app_dummy_test1
  end

  test "@dummy_test2" do
    assert @dummy_test2 == :absolutely_too
    assert @dummy_test2 == @app_dummy_test2
  end

  test "@all_logger_env" do
    assert Keyword.has_key?(@all_logger_env, :truncate)
  end

  test "@all_what_env" do
    assert @all_what_env == []
  end
end
