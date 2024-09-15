defmodule Utils do
  @spec meassure_time((-> any())) :: integer()
  def meassure_time(f) do
    time = System.os_time(:millisecond)
    f.()
    System.os_time(:millisecond) - time
  end

  @spec put_lines([String.t()]) :: list()
  def put_lines(lines) do
    lines
    |> Enum.map(&IO.puts/1)
  end
end
