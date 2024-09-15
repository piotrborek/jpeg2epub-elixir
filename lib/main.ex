defmodule Main do
  use Application

  @impl Application
  @spec start(any(), any()) :: no_return()
  def start(_type, _args) do
    #children = [ ]
    #opts = [strategy: :one_for_one, name: Sample.Supervisor]
    #Supervisor.start_link(children, opts)

    time = Utils.meassure_time fn ->
      Application.put_env(:elixir, :ansi_enabled, true)
      run_app()
    end

    Log.put_info ["It took: ", "#{time}", " ms."]

    System.halt 0
  end

  @spec run_app() :: :ok
  def run_app() do
    Logo.print_logo()

    binaries = Tools.get_binaries!()
    cli = Cli.parse_cli!()
    dirs = Directories.create_directories!("epub")

    try do
      Epub.create_epub! %AppConfig{
        binaries: binaries,
        cli: cli,
        directories: dirs
      }
    after
      IO.puts("")

      if not cli.keep_temp, do: File.rm_rf!(dirs.root)
    end
  end

  @spec main(any()) :: no_return()
  def main(_args), do: start(:normal, [])
end
