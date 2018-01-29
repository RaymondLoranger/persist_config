defmodule PersistConfigAppTest do
  use ExUnit.Case, async: true
  use PersistConfig, app_attr: :this_app

  doctest PersistConfig

  test "@this_app is the current application" do
    assert @this_app == :persist_config
  end
end
