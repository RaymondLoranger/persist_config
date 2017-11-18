defmodule PersistConfigAppTest do
  use ExUnit.Case
  use PersistConfig, app: :this_app

  doctest PersistConfig

  test "@this_app is the configured application" do
    assert @this_app == :persist_config
  end
end
