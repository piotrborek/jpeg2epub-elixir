defmodule AppConfig do
  use TypedStruct

  typedstruct enforce: true, module: Binaries do
    field :zip_path, String.t()
    field :unzip_path, String.t()
    field :magick_path, String.t()
  end

  typedstruct enforce: true, module: Directories do
    field :root, String.t()
    field :epub, String.t()
    field :images, String.t()
    field :metainf, String.t()
    field :styles, String.t()
    field :text, String.t()
    field :unzip, String.t()
  end

  typedstruct enforce: true, module: Cli do
    field :input, String.t()
    field :quality, integer()
    field :from_file, boolean()
    field :from_directory, boolean()
    field :keep_temp, boolean()
    field :override, boolean()
    field :trim, boolean()
  end

  typedstruct enforce: true do
    field :binaries, Binaries.t()
    field :directories, Directories.t()
    field :cli, Cli.t()
  end
end
