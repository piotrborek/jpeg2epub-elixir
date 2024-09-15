defmodule Tools do
  @zip "zip"
  @unzip "unzip"
  @magick "magick"

  @spec get_binaries!() :: AppConfig.Binaries.t()
  def get_binaries!() do
    zip = find_in_path(@zip)
    unzip = find_in_path(@unzip)
    magick = find_in_path(@magick)

    if zip == :error, do: program_not_found(@zip) |> Log.put_error()
    if unzip == :error, do: program_not_found(@unzip) |> Log.put_error()
    if magick == :error, do: program_not_found(@magick) |> Log.put_error()

    with { :ok, zip_path } <- zip,
         { :ok, unzip_path } <- unzip,
         { :ok, magick_path } <- magick
    do
      %AppConfig.Binaries{
        zip_path: zip_path,
        unzip_path: unzip_path,
        magick_path: magick_path
      }
    else
      _ -> System.halt 1
    end
  end

  @spec find_in_path(String.t()) :: :error | {:ok, String.t()}
  defp find_in_path(file_name) do
    system_path =
      System.get_env("PATH")
      |> String.split(":")

    file_path = Enum.find(system_path, fn path ->
      File.exists?(Path.join [path, file_name])
    end)

    case file_path do
      nil -> :error
      _   -> { :ok, Path.join [file_path, file_name] }
    end
  end

  defp program_not_found(name), do: "Program #{name} could not be found in the PATH or is not executable"
end
