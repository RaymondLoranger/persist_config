defmodule PersistConfigTest do
  use ExUnit.Case, async: true
  use PersistConfig

  doctest PersistConfig

  test "@app is the configured application" do
    assert @app == :persist_config
  end
end
