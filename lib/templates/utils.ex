defmodule Templates.Utils do
  @spec integer_to_imagename(integer()) :: String.t()
  def integer_to_imagename(i), do: "#{Integer.to_string(i) |> String.pad_leading(4, "0")}.jpg"

  @spec integer_to_textname(integer()) :: String.t()
  def integer_to_textname(i), do: "Page#{Integer.to_string(i) |> String.pad_leading(4, "0")}.html"
end
