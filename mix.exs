defmodule Wok.Tests.Mixfile do
	use Mix.Project

	def project do
		[app: :wok_tests,
		 version: "0.0.1",
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
			{:bucs, ~r/.*/, git: "https://github.com/botsunit/bucs.git", branch: "master"},  
			{:wok_http_adapter, ~r/.*/, git: "git@gitlab.botsunit.com:msaas/wok_http_adapter.git", branch: "master"},  
			{:meck, ~r/.*/, git: "https://github.com/eproxus/meck.git", branch: "master"},  
			{:hackney, ~r/.*/, git: "https://github.com/benoitc/hackney.git", branch: "master"},  
			{:doteki, ~r/.*/, git: "https://github.com/botsunit/doteki.git", branch: "master"},
		]
	end
end
