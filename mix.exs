defmodule Wok.Tests.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wok_tests,
      version: "0.1.2",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps
    ]
  end

  def application do
    [
       applications: [:kernel, :stdlib],
       env: []
    ]
  end

  defp deps do
    [
      {:bucs, git: "https://github.com/botsunit/bucs.git", branch: "master"},
      {:wok_http_adapter, git: "git@gitlab.botsunit.com:msaas/wok_http_adapter.git", branch: "master"},
      {:wok_message_handler, git: "git@gitlab.botsunit.com:msaas/wok_message_handler.git", branch: "master"},
      {:doteki, git: "https://github.com/botsunit/doteki.git", branch: "master"},
      {:hackney, "~> 1.6.0"}    
    ]
  end
end