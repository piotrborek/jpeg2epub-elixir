defmodule Templates.Mimetype do
  @spec write_mimetype!(AppConfig.t()) :: :ok
  def write_mimetype!(%AppConfig{} = config) do
    """
    application/epub+zip
    """ |> write!(config)
  end

  @spec write!(String.t(), AppConfig.t()) :: :ok
  defp write!(text, %AppConfig{} = config), do: File.write!(Path.join([config.directories.epub, "mimetype"]), text |> String.trim())
end
