defmodule PersistConfig.Proxy do
  @moduledoc false

  # E.g. maybe_drop(config, file_only_logger: [:logger, :padding, :line_length])
  # E.g. maybe_drop(config, logger: [:default_formatter])
  @spec maybe_drop(keyword, keyword) :: keyword
  def maybe_drop(config, [{app, [key | _]}] = keyword) do
    # Check if `app` already configured e.g. in parent app...
    if :application.get_env(app, key) == :undefined do
      config
    else
      drop(config, keyword)
    end
  end

  ## Private functions

  @spec drop(keyword, keyword) :: keyword
  defp drop(config, [{app, keys}]) do
    config =
      Enum.reduce(keys, config, fn k, acc ->
        {_val, acc} = pop_in(acc[app][k])
        acc
      end)

    if Enum.empty?(config[app]) do
      # E.g. [file_only_logger: [...], logger: []] => [file_only_logger: [...]]
      pop_in(config[app])
    else
      config
    end
  end
end
