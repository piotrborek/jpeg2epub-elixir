defmodule Jpeg2epub.MixProject do
  use Mix.Project

  def project do
    [
      app: :jpeg2epub,
#      releases: releases(),
      version: "0.2.0",
      elixir: "~> 1.17",
      escript: escript(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

#  def releases do
#    [
#      main: [
#        steps: [:assemble, &Burrito.wrap/1],
#        burrito: [
#          targets: [
#            # macos: [os: :darwin, cpu: :x86_64],
#            linux: [os: :linux, cpu: :x86_64]
#            # windows: [os: :windows, cpu: :x86_64]
#          ],
#        ]
#      ]
#    ]
#  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [ :logger ],
      mod: { Main, [] }
    ]
  end

  def escript() do
    [main_module: Main]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      { :progress_bar, "~> 3.0" },
      { :typedstruct, "~> 0.5.3", runtime: false },
      { :optimus, "~> 0.5.0" },

#      { :burrito, "~> 1.1", only: [:dev, :test], runtime: false },
      { :dialyxir, "~> 1.4", only: [:dev, :test], runtime: false },
    ]
  end
end
