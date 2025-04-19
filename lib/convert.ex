defmodule Convert do
  @spec convert!(AppConfig.t()) :: integer()
  def convert!(%AppConfig{} = config) do
    image_list = Images.list_images(config) |> Images.sort_images()

    args_list = create_arg_list(image_list, config)
    IO.puts(inspect(args_list))
    convert_cmd = &System.cmd(config.binaries.magick_path, &1)
    no_cpus = System.schedulers_online()

    args_list
    |> Task.async_stream(convert_cmd, max_concurrency: no_cpus)
    |> Enum.reduce(fn {:ok, _result}, _acc -> :ok end)

    length(args_list)
  end

  @spec create_arg_list([binary()], AppConfig.t()) :: [[binary()]]
  defp create_arg_list(images, %AppConfig{} = config) do
    area = config.cli.cut_area

    images
    |> Enum.with_index(1)
    |> Enum.map(fn {src, index} ->
      list = [src]

      list =
        if config.cli.trim and not has_cut_area(config.cli.cut_area),
          do: ["-trim", "10%", "-fuzz" | list],
          else: list

      list =
        if has_cut_area(config.cli.cut_area),
          do: ["#{area.width}x#{area.height}+#{area.x}+#{area.y}", "-crop" | list],
          else: list

      list = ["-quality" | list]
      list = ["#{config.cli.quality}" | list]

      list = [
        Path.join(config.directories.images, Templates.Utils.integer_to_imagename(index)) | list
      ]

      Enum.reverse(list)
    end)
  end

  defp has_cut_area(%AppConfig.Area{} = area),
    do: area.x != 0 or area.y != 0 or area.width != 0 or area.height != 0
end

#        if (cutArea.top != 0 || cutArea.top != 0) args.push("-chop", `${cutArea.left}x${cutArea.top}`)
#        if (cutArea.right) args.push("-gravity", "East", "-chop", `${cutArea.right}x0`)
#        if (cutArea.bottom) args.push("-gravity", "South", "-chop", `0x${cutArea.bottom}`)
#        if (cli.resize.width != 0 && cli.resize.height != 0) args.push("-resize", `${cli.resize.width}x${cli.resize.height}`)
