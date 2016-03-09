PROJECT = wok_tests

DEP_PLUGINS = mix.mk
BUILD_DEPS = mix.mk
ELIXIR_VERSION = ~> 1.2
ELIXIR_BINDINGS = wok_tests

dep_mix.mk = git https://github.com/botsunit/mix.mk.git master

DEPS = bucs wok_http_adapter meck hackney doteki
dep_bucs = git https://github.com/botsunit/bucs.git master
dep_wok_http_adapter = git git@gitlab.botsunit.com:msaas/wok_http_adapter.git master
dep_doteki = git https://github.com/botsunit/doteki.git master
dep_meck = git https://github.com/eproxus/meck.git master
dep_hackney = git git://github.com/benoitc/hackney.git master

DOC_DEPS = edown
dep_edown = git https://github.com/botsunit/edown.git master

EDOC_OPTS = {doclet, edown_doclet} \
						, {app_default, "http://www.erlang.org/doc/man"} \
						, {source_path, ["src"]} \
						, {overview, "overview.edoc"} \
						, {stylesheet, ""} \
						, {image, ""} \
						, {edown_target, gitlab} \
						, {top_level_readme, {"./README.md", "https://gitlab.botsunit.com/msaas/${PROJECT}"}}

EUNIT_OPTS = verbose, {report, {eunit_surefire, [{dir, "test"}]}}

include erlang.mk

CP = cp

docs:: edoc
	@${CP} _doc/* doc

dev: deps app
	@erl -pa ebin include deps/*/ebin deps/*/include

release: app mix.all

