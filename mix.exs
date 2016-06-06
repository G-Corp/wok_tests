defmodule Wok.Tests.Mixfile do
  use Mix.Project

  def project do
    [app: :wok_tests,
     version: "0.1.2",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [ 
      {:bucs, ~r/.*/, git: "https://github.com/botsunit/bucs.git", tag: "0.0.1"},  
      {:wok_http_adapter, ~r/.*/, git: "git@gitlab.botsunit.com:msaas/wok_http_adapter.git", tag: "0.0.4"},  
      {:wok_message_handler, ~r/.*/, git: "git@gitlab.botsunit.com:msaas/wok_message_handler.git", tag: "0.2.1"},  
      {:doteki, ~r/.*/, git: "https://github.com/botsunit/doteki.git", tag: "0.0.1"},  
      {:hackney, ">= 0.12.0"},
    ]
  end
end
