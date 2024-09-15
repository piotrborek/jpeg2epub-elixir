defmodule Directories do
  @images "Images"
  @metainf "META-INF"
  @styles "Styles"
  @text "Text"
  @epub "epub"
  @unzip "unzip"

  @spec create_directories!(String.t()) :: AppConfig.Directories.t()
  def create_directories!(prefix \\ "") do
    root = FileUtils.create_temp_dir!(prefix)

    unzip = Path.join [root, @unzip]
    epub = Path.join [root, @epub]
    images = Path.join [root, @epub, @images]
    metainf = Path.join [root,  @epub, @metainf]
    styles = Path.join [root,  @epub, @styles]
    text = Path.join [root,  @epub, @text]

    Enum.each [unzip, epub, images, metainf, styles, text], &File.mkdir!/1

    %AppConfig.Directories{
      root: root,
      epub: epub,
      images: images,
      metainf: metainf,
      styles: styles,
      text: text,
      unzip: unzip
    }
  end
end
