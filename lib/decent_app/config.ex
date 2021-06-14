defmodule DecentApp.Config do
  alias DecentApp.Balance

  @config %{
    "POP" => %{
      cost: 1,
      required_length: 1,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)

          # Function execution Logic
          {_, res} = List.pop_at(res, length(res) - 1)
          res
        end
    },
    "DUP" => %{
      cost: 1,
      required_length: 1,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)

          # Function execution Logic
          res ++ [List.last(res)]
        end
    },
    "+" => %{
      cost: 2,
      required_length: 2,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)

          # Function execution Logic
          [first, second | rest] = Enum.reverse(res)
          Enum.reverse(rest) ++ [first + second]
        end
    },
    "-" => %{
      cost: 1,
      required_length: 2,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)

          # Function execution Logic
          [first, second | rest] = Enum.reverse(res)
          Enum.reverse(rest) ++ [first - second]
        end
    },
    "*" => %{
      cost: 3,
      required_length: 3,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)

          # Function execution Logic
          [first, second, third | rest] = Enum.reverse(res)
          Enum.reverse(rest) ++ [first * second * third]
        end
    },
    "COINS" => %{
      cost: -5,
      required_length: 0,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)

          # Function execution Logic
          res
        end
    },
    "NOTHING" => %{
      cost: 1,
      required_length: 0,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)

          # Function execution Logic
          res
        end
    },
    "0" => %{
      cost: 1,
      required_length: 0,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)
          # Function execution Logic
          res ++ [0]
        end
    },
    "1" => %{
      cost: 1,
      required_length: 0,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)
          # Function execution Logic
          res ++ [1]
        end
    },
    "2" => %{
      cost: 1,
      required_length: 0,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)
          # Function execution Logic
          res ++ [2]
        end
    },
    "3" => %{
      cost: 1,
      required_length: 0,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)
          # Function execution Logic
          res ++ [3]
        end
    },
    "4" => %{
      cost: 1,
      required_length: 0,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)
          # Function execution Logic
          res ++ [4]
        end
    },
    "5" => %{
      cost: 1,
      required_length: 0,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)
          # Function execution Logic
          res ++ [5]
        end
    },
    "6" => %{
      cost: 1,
      required_length: 0,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)
          # Function execution Logic
          res ++ [6]
        end
    },
    "7" => %{
      cost: 1,
      required_length: 0,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)
          # Function execution Logic
          res ++ [7]
        end
    },
    "8" => %{
      cost: 1,
      required_length: 0,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)
          # Function execution Logic
          res ++ [8]
        end
    },
    "9" => %{
      cost: 1,
      required_length: 0,
      execution:
        quote do
          # Capturing args from caller
          res = var!(res)
          # Function execution Logic
          res ++ [9]
        end
    }
  }


  for {command, val} <- @config do
    def new_balance(unquote(command), %Balance{} = bal),
      do: {bal.coins - unquote(val.cost) < 0, %{bal | coins: bal.coins - unquote(val.cost)}}

    def check_error(unquote(command), list), do: length(list) < unquote(val.required_length)

    def execute(unquote(command), balance, res) do
      with false <- check_error(unquote(command), res),
           {false, balance} <- new_balance(unquote(command), balance) do
        {balance, unquote(val.execution)}
      else
        _ ->
          -1
      end
    end
  end

  def execute(_, _, _), do: -1
end
