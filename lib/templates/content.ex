defmodule Templates.Content do
  require EEx

  @template """
  <?xml version="1.0"?>
  <package unique-identifier="bookid" version="2.0" xmlns="http://www.idpf.org/2007/opf" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <metadata xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:opf="http://www.idpf.org/2007/opf" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:calibre="http://calibre.kovidgoyal.net/2009/metadata" xmlns:dc="http://purl.org/dc/elements/1.1/">
      <dc:title><%= title %></dc:title>
      <dc:language>pl</dc:language>
    </metadata>
    <manifest>
      <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
      <item id="style" href="Styles/main.css" media-type="text/css"/>
  <%= 1..no_images |> Enum.map(fn index -> %>
      <item id="img<%= index %>" href="Images/<%= Templates.Utils.integer_to_imagename(index)%>" media-type="image/jpeg"/><% end) %>
  <%= 1..no_images |> Enum.map(fn index -> %>
      <item id="txt<%= index %>" href="Text/<%= Templates.Utils.integer_to_textname(index)%>" media-type="application/xhtml+xml"/><% end) %>
    </manifest>
    <spine toc="ncx"><%= 1..no_images |> Enum.map(fn index -> %>
      <itemref idref="txt<%= index %>"/><% end) %>
    </spine>
  </package>
  """ |> String.trim

  EEx.function_from_string(:def, :content, @template, [:title, :no_images])

  @spec write_content!(AppConfig.t(), integer()) :: :ok
  def write_content!(%AppConfig{} = config, no_images) do
    content(config.cli.input |> Path.basename, no_images) |> write!(config)
  end

  @spec write!(String.t(), AppConfig.t()) :: :ok
  defp write!(text, %AppConfig{} = config), do: File.write!(Path.join([config.directories.epub, "content.opf"]), text)
end
