defmodule ExAws.Polly.Mixfile do
  use Mix.Project

  @version "0.2.0"
  @service "polly"
  @url "https://github.com/josephan/ex_aws_#{@service}"
  @name __MODULE__ |> Module.split |> Enum.take(2) |> Enum.join(".")

  def project do
    [
      app: :ex_aws_polly,
      version: @version,
      elixir: "~> 1.4",
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  defp package do
    [description: "#{@name} service package",
     files: ["lib", "config", "mix.exs", "README*"],
     maintainers: ["Joseph An"],
     licenses: ["MIT"],
     links: %{github: @url},
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib",]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:hackney, ">= 0.0.0", only: [:dev, :test]},
      {:sweet_xml, ">= 0.0.0", only: [:dev, :test]},
      {:bypass, "~> 0.7", only: :test},
      ex_aws(),
    ]
  end

  defp ex_aws() do
    case System.get_env("AWS") do
      "LOCAL" -> {:ex_aws, path: "../ex_aws"}
      _ -> {:ex_aws, "~> 2.0.0"}
    end
  end
end
