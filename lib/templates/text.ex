defmodule Templates.Text do
  require EEx

  @template """
  <?xml version="1.0" encoding="utf-8"?>
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <link href="../Styles/main.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
      <div>
        <img alt="" src="../Images/<%= imagename %>"/>
      </div>
    </body>
  </html>
  """ |> String.trim

  EEx.function_from_string(:def, :text, @template, [:imagename])

  @spec write_text!(AppConfig.t(), integer()) :: :ok
  def write_text!(%AppConfig{} = config, no_images) do
    Enum.each 1..no_images, fn index ->
      filename = Templates.Utils.integer_to_textname(index)
      Templates.Utils.integer_to_imagename(index) |> text |> write!(filename, config)
    end
  end

  @spec write!(String.t(), String.t(), AppConfig.t()) :: :ok
  defp write!(text, filename, %AppConfig{} = config), do: File.write!(Path.join([config.directories.text, filename]), text)
end
