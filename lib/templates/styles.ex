defmodule Templates.Styles do
  @spec write_css!(AppConfig.t()) :: :ok
  def write_css!(%AppConfig{} = config) do
    """
    * {
      padding: 0;
      margin: 0;
      text-align: center;
    }

    img {
      height: 100%;
      width: auto;
    }
    """ |> write!(config)
  end

  @spec write!(String.t(), AppConfig.t()) :: :ok
  defp write!(text, %AppConfig{} = config), do: File.write!(Path.join([config.directories.styles, "main.css"]), text |> String.trim())
end
