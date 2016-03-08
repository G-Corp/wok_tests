# File: lib/Wok.Tests.ex
# This file was generated from src/wok_tests.erl
# Using mix.mk (https://github.com/botsunit/mix.mk)
# MODIFY IT AT YOUR OWN RISK AND ONLY IF YOU KNOW WHAT YOU ARE DOING!
defmodule Wok.Tests do
	def unquote(:"create_req")(arg1, arg2, arg3) do
		:erlang.apply(:"wok_tests", :"create_req", [arg1, arg2, arg3])
	end
	def unquote(:"request")(arg1, arg2, arg3) do
		:erlang.apply(:"wok_tests", :"request", [arg1, arg2, arg3])
	end
	def unquote(:"request")(arg1, arg2, arg3, arg4, arg5, arg6) do
		:erlang.apply(:"wok_tests", :"request", [arg1, arg2, arg3, arg4, arg5, arg6])
	end
	def unquote(:"follow")(arg1, arg2, arg3) do
		:erlang.apply(:"wok_tests", :"follow", [arg1, arg2, arg3])
	end
	def unquote(:"submit")(arg1, arg2, arg3, arg4) do
		:erlang.apply(:"wok_tests", :"submit", [arg1, arg2, arg3, arg4])
	end
	def unquote(:"assert")(arg1) do
		:erlang.apply(:"wok_tests", :"assert", [arg1])
	end
	def unquote(:"assert_not")(arg1) do
		:erlang.apply(:"wok_tests", :"assert_not", [arg1])
	end
	def unquote(:"assert_equal")(arg1, arg2) do
		:erlang.apply(:"wok_tests", :"assert_equal", [arg1, arg2])
	end
	def unquote(:"assert_not_equal")(arg1, arg2) do
		:erlang.apply(:"wok_tests", :"assert_not_equal", [arg1, arg2])
	end
	def unquote(:"assert_request_ok")(arg1) do
		:erlang.apply(:"wok_tests", :"assert_request_ok", [arg1])
	end
	def unquote(:"assert_request_code")(arg1, arg2) do
		:erlang.apply(:"wok_tests", :"assert_request_code", [arg1, arg2])
	end
	def unquote(:"assert_request_not_code")(arg1, arg2) do
		:erlang.apply(:"wok_tests", :"assert_request_not_code", [arg1, arg2])
	end
	def unquote(:"assert_request_has_body")(arg1) do
		:erlang.apply(:"wok_tests", :"assert_request_has_body", [arg1])
	end
	def unquote(:"assert_request_not_has_body")(arg1) do
		:erlang.apply(:"wok_tests", :"assert_request_not_has_body", [arg1])
	end
	def unquote(:"assert_request_redirect")(arg1) do
		:erlang.apply(:"wok_tests", :"assert_request_redirect", [arg1])
	end
	def unquote(:"assert_request_not_found")(arg1) do
		:erlang.apply(:"wok_tests", :"assert_request_not_found", [arg1])
	end
	def unquote(:"assert_request_header")(arg1, arg2) do
		:erlang.apply(:"wok_tests", :"assert_request_header", [arg1, arg2])
	end
	def unquote(:"debug")(arg1, arg2) do
		:erlang.apply(:"wok_tests", :"debug", [arg1, arg2])
	end
	def unquote(:"debug")(arg1) do
		:erlang.apply(:"wok_tests", :"debug", [arg1])
	end
	def unquote(:"test")() do
		:erlang.apply(:"wok_tests", :"test", [])
	end
end
