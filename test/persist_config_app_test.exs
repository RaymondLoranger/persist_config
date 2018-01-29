defmodule PersistConfigAppTest do
  use ExUnit.Case, async: true
  use PersistConfig, app: :this_app

  doctest PersistConfig

  test "@this_app is the current application" do
    assert @this_app == :persist_config
  end
end
