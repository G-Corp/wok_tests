defmodule Wok.Tests.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wok_tests,
      version: "0.2.1",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps
    ]
  end

  def application do
    [
       applications: [],
       env: []
    ]
  end

  defp deps do
    [
      {:bucs, "~> 0.1.0"},
      {:wok_http_adapter, git: "git@gitlab.botsunit.com:msaas/wok_http_adapter.git", tag: "0.1.0"},
      {:wok_message_handler, git: "git@gitlab.botsunit.com:msaas/wok_message_handler.git", tag: "0.4.0"},
      {:doteki, "~> 0.1.0"},
      {:hackney, "~> 1.6.0"}    
    ]
  end
end