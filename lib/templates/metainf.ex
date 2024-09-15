defmodule Templates.Metainf do
  @spec write_metainf!(AppConfig.t()) :: :ok
  def write_metainf!(%AppConfig{} = config) do
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
      <rootfiles>
        <rootfile full-path="content.opf" media-type="application/oebps-package+xml"/>
      </rootfiles>
    </container>
    """ |> write!(config)
  end

  @spec write!(String.t(), AppConfig.t()) :: :ok
  defp write!(text, %AppConfig{} = config), do: File.write!(Path.join([config.directories.metainf, "container.xml"]), text |> String.trim())
end
