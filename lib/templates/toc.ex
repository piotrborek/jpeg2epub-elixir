defmodule Templates.Toc do
  require EEx

  @template """
  <?xml version='1.0' encoding='utf-8'?>
  <ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1" xml:lang="pol">
  <navMap><%= 1..no_images |> Enum.map(fn index -> %>
    <navPoint class="chapter" id="n<%= index %>" playOrder="<%= index %>">
      <navLabel>
        <text>Page <%= index %></text>
      </navLabel>
      <content src="Text/<%= Templates.Utils.integer_to_textname(index)%>"/>
    </navPoint><% end) %>
  </navMap>
  </ncx>
  """ |> String.trim

  EEx.function_from_string(:def, :toc, @template, [:no_images])

  @spec write_toc!(AppConfig.t(), integer()) :: :ok
  def write_toc!(%AppConfig{} = config, no_images) do
    toc(no_images) |> write!(config)
  end

  @spec write!(String.t(), AppConfig.t()) :: :ok
  defp write!(text, %AppConfig{} = config), do: File.write!(Path.join([config.directories.epub, "toc.ncx"]), text)
end
