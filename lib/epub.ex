defmodule Epub do
  import Templates.{ Styles, Metainf, Mimetype, Text, Content, Toc }

  @spec create_epub!(AppConfig.t()) :: :ok
  def create_epub!(%AppConfig{} = config) do
    "Decompressing files" |> ProgressLine.render([skip: not config.cli.from_file], fn ->
      decompress!(config)
    end)

    no_images = "Processing files" |> ProgressLine.render(fn ->
      Convert.convert!(config)
    end)

    "Generating files" |> ProgressLine.render(fn ->
      write_css!(config)
      write_metainf!(config)
      write_mimetype!(config)
      write_text!(config, no_images)
      write_content!(config, no_images)
      write_toc!(config, no_images)
    end)

    "Compressing" |> ProgressLine.render(fn ->
      compress_to_file!(config)
    end)

    :ok
  end

  @spec compress_to_file!(AppConfig.t()) :: :ok
  defp compress_to_file!(%AppConfig{} = config) do
    current_dir = File.cwd!()
    File.cd!(config.directories.epub)

    System.cmd(config.binaries.zip_path, ["-r", config.cli.input <> ".epub", "."])

    File.cd!(current_dir)
  end

  @spec decompress!(AppConfig.t()) :: :ok
  defp decompress!(%AppConfig{} = config) do
    System.cmd(config.binaries.unzip_path, [config.cli.input, "-d", config.directories.unzip])

    :ok
  end
end
