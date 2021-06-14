defmodule DecentApp do
  alias DecentApp.Balance
  alias DecentApp.Config

  def call(%Balance{} = balance, commands), do: call_recurr(commands, balance, [])

  def call_recurr([], balance, res), do: {balance, res}

  def call_recurr([command | commands], balance, res) do
    command =
      if is_integer(command),
        do: Integer.to_string(command),
        else: command

    case Config.execute(command, balance, res) do
      {balance, res} ->
        call_recurr(commands, balance, res)

      -1 ->
        -1
    end
  end
end
