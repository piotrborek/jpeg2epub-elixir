defmodule Convert do
  @spec convert!(AppConfig.t()) :: integer()
  def convert!(%AppConfig{} = config) do
    image_list = Images.list_images(config) |> Images.sort_images()

    args_list = create_arg_list(image_list, config)
    convert_cmd = &System.cmd(config.binaries.magick_path, &1)
    no_cpus = System.schedulers_online()

    args_list
      |> Task.async_stream(convert_cmd , max_concurrency: no_cpus)
      |> Enum.reduce(fn { :ok, _result }, _acc  -> :ok end)

    length(args_list)
  end

  @spec create_arg_list([binary()], AppConfig.t()) :: [[binary()]]
  defp create_arg_list(images, %AppConfig{} = config) do
    images
    |> Enum.with_index(1)
    |> Enum.map(fn { src, index } ->
         list = [src]
         list = if config.cli.trim, do: ["-trim", "10%", "-fuzz" | list], else: list
         list = ["-quality" | list]
         list = ["#{config.cli.quality}" | list]
         list = [Path.join(config.directories.images, Templates.Utils.integer_to_imagename(index)) | list]
         Enum.reverse(list)
       end)
  end
end
