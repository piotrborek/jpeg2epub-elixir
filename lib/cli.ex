defmodule Cli do
  @spec parse_cli!() :: AppConfig.Cli.t()
  def parse_cli!() do
    argv = System.argv()

    cli = create_cli!()
    parsed = Optimus.parse!(cli, argv)

    if parsed.flags.from_file and parsed.flags.from_directory,
      do: exit_with_error(cli, "Flags -I and -i cannot be used together.")

    if not parsed.flags.from_file and not parsed.flags.from_directory,
      do: exit_with_error(cli, "Flag -i or -I is required.")

    input = parsed.args.input |> Path.absname() |> Path.expand()

    if parsed.flags.from_file and not File.exists?(input),
      do: exit_with_error(cli, "File #{input |> Path.basename()} does not exists.")

    if parsed.flags.from_directory and not File.exists?(input),
      do: exit_with_error(cli, "Directory #{input |> Path.basename()} does not exists.")

    file = input <> ".epub"

    if File.exists?(file) do
      if parsed.flags.override do
        File.rm!(file)
      else
        exit_with_error(cli, "File #{file |> Path.basename()} already exists.")
      end
    end

    IO.puts(inspect(parsed.options.cut_area))

    %AppConfig.Cli{
      input: input,
      quality: parsed.options.quality,
      cut_area: parsed.options.cut_area,
      from_file: parsed.flags.from_file,
      from_directory: parsed.flags.from_directory,
      keep_temp: parsed.flags.keep_temp,
      override: parsed.flags.override,
      trim: parsed.flags.trim
    }
  end

  @spec exit_with_error(Optimus.t(), String.t()) :: no_return()
  defp exit_with_error(cli, text) do
    cli |> Optimus.Errors.format([text]) |> Utils.put_lines()
    System.halt(1)
  end

  @spec parse_cut_area(String.t()) :: AppConfig.Area.t()
  defp parse_cut_area(s) do
    area = s |> String.split() |> Enum.map(&Integer.parse/1)

    cut_area =
      with {x, _} <- Enum.at(area, 0),
           {y, _} <- Enum.at(area, 1),
           {width, _} <- Enum.at(area, 2),
           {height, _} <- Enum.at(area, 3) do
        %AppConfig.Area{
          x: x,
          y: y,
          width: width,
          height: height
        }
      else
        _ ->
          %AppConfig.Area{
            x: 0,
            y: 0,
            width: 0,
            height: 0
          }
      end

    {:ok, cut_area}
  end

  @spec create_cli!() :: Optimus.t()
  defp create_cli!() do
    Optimus.new!(
      name: "jpeg2epub",
      version: "1.0.0",
      author: "Piotr Borek piotrborek@op.pl",
      about: "Utility to make single epub files from images.",
      allow_unknown_args: false,
      args: [
        input: [
          value_name: "INPUT",
          help: "Input file or directory.",
          required: true,
          parser: :string
        ]
      ],
      flags: [
        from_file: [
          short: "-i",
          help: "Get input images from a file."
        ],
        from_directory: [
          short: "-I",
          help: "Get input images from a directory."
        ],
        keep_temp: [
          long: "--keep-temp",
          help: "Don't delete temp directory."
        ],
        override: [
          short: "-w",
          help: "Override output file if exists."
        ],
        trim: [
          short: "-C",
          help: "Removes any edges that are exactly the same color as the corner pixels."
        ]
      ],
      options: [
        quality: [
          long: "--quality",
          help: "Output jpeg image quality.",
          parser: :integer,
          required: false,
          default: 90
        ],
        cut_area: [
          long: "--cut",
          help: "Cut area from images. Format: \"x y width height\"",
          parser: &parse_cut_area/1,
          required: false,
          default: ""
        ]
      ]
    )
  end
end
