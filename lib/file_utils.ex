defmodule FileUtils do
  @spec create_temp_dir!(String.t(), integer()) :: String.t()
  def create_temp_dir!(prefix \\ "", randon_bytes \\ 16) do
    tmp = System.tmp_dir!()
    rand = :crypto.strong_rand_bytes(randon_bytes) |> Base.url_encode64(padding: false)
    dst = if String.trim(prefix) == "", do: rand, else: prefix <> "_" <> rand
    path = Path.join([tmp, dst])
    File.mkdir_p!(path)
    path
  end
end
