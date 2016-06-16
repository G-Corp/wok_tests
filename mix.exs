defmodule Wok.Tests.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wok_tests,
      version: "0.2.0",
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
      {:bucs, git: "https://github.com/botsunit/bucs.git", tag: "0.0.2"},
      {:wok_http_adapter, git: "git@gitlab.botsunit.com:msaas/wok_http_adapter.git", tag: "0.1.0"},
      {:wok_message_handler, git: "git@gitlab.botsunit.com:msaas/wok_message_handler.git", tag: "0.3.0"},
      {:doteki, git: "https://github.com/botsunit/doteki.git", tag: "0.1.0"},
      {:hackney, "~> 1.6.0"}    
    ]
  end
end