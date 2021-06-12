defmodule DecentApp do
  alias DecentApp.Balance

  def call(%Balance{} = balance, commands) do
    {balance, result, error} = call_recurr(commands, balance, [], false)
    if error, do: -1, else: {balance, result}
  end

  def call_recurr([], balance, res, false), do: {balance, res, false}

  def call_recurr([command | commands], balance, res, false) do
    with false <- check_error(command, res),
         {false, balance} <- new_balance(command, balance) do
      res = execute(command, res)
      call_recurr(commands, balance, res, false)
    else
      _ ->
        {nil, nil, true}
    end
  end

  def call_recurr(_, _, _, true), do: {nil, nil, true}

  def check_error(command, list) when command in ["DUP", "POP"], do: length(list) < 1
  def check_error(command, list) when command in ["+", "-"], do: length(list) < 2
  def check_error(command, list) when command in ["*"], do: length(list) < 3
  def check_error(command, _list) when command in ["COINS", "NOTHING"], do: false
  def check_error(command, _list) when is_integer(command), do: command < 0 || command > 10
  def check_error(_command, _list), do: true

  def new_balance(command, %Balance{} = bal) when command == "COINS",
    do: {false, %{bal | coins: bal.coins + 5}}

  def new_balance(command, %Balance{} = bal) when command == "+",
    do: {bal.coins - 2 < 0, %{bal | coins: bal.coins - 2}}

  def new_balance(command, %Balance{} = bal) when command == "*",
    do: {bal.coins - 3 < 0, %{bal | coins: bal.coins - 3}}

  def new_balance(_command, %Balance{} = bal),
    do: {bal.coins - 1 < 0, %{bal | coins: bal.coins - 1}}

  def execute("DUP", res), do: res ++ [List.last(res)]
  def execute("COINS", res), do: res
  def execute("NOTHING", res), do: res

  def execute("POP", res) do
    {_, res} = List.pop_at(res, length(res) - 1)
    res
  end

  def execute("+", res) do
    [first, second | rest] = Enum.reverse(res)
    res = Enum.reverse(rest) ++ [first + second]
    res
  end

  def execute("-", res) do
    [first, second | rest] = Enum.reverse(res)
    res = Enum.reverse(rest) ++ [first - second]
    res
  end

  def execute("*", res) do
    [first, second, third | rest] = Enum.reverse(res)
    res = Enum.reverse(rest) ++ [first * second * third]
    res
  end

  def execute(command, res) when is_integer(command), do: res ++ [command]
end
