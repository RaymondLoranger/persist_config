defmodule Mix.Tasks.Gen do
  @moduledoc false

  use Mix.Task

  @spec run(OptionParser.argv) :: :ok
  def run(_args) do
    Mix.Tasks.Cmd.run ~w/mix compile/
    Mix.Tasks.Cmd.run ~w/mix test/
    Mix.Tasks.Cmd.run ~w/mix docs/
  end
end