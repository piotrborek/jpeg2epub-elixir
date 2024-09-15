defmodule ProgressLine do
  @spec render(String.t(), keyword(), (-> t)) :: t when t: any()
  def render(text, opts \\ [], fun) do
    skip = Keyword.get(opts, :skip, false)

    if skip do
      IO.puts([IO.ANSI.yellow, skip_symbol(), " ", IO.ANSI.reset, text])
    else
      format = format_new(text)
      ProgressBar.render_spinner format, fun
    end
  end

  defp format_new(text) when is_binary(text), do:
    [
      frames: ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"],
      spinner_color: IO.ANSI.magenta,
      text: IO.ANSI.bright() <> text,
      done: [IO.ANSI.green, "✔", IO.ANSI.reset, " " <> text]
    ]

  defp skip_symbol, do: "↓"
end
