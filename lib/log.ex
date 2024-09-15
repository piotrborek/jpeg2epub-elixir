defmodule Log do
  @spec put_info(String.t() | [String.t()]) :: :ok
  def put_info(message), do: [:green, message] |> IO.ANSI.format() |> IO.puts()

  @spec put_info(String.t() | [String.t()]) :: :ok
  def put_error(message), do: [:red, message] |> IO.ANSI.format() |> IO.puts()
end
