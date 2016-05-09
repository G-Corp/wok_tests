-module(wok_assert_tests).

-include_lib("eunit/include/eunit.hrl").

assert_test_() ->
  {setup,
   fun() -> ok end,
   fun(_) -> ok end,
   [
    fun() ->
        wok_tests:assert(true),
        wok_tests:assert_not(false),
        wok_tests:assert_equal(a, a),
        wok_tests:assert_not_equal(1, 1+1)
    end
   ]}.

assert_http_test_() ->
  {setup,
   fun() -> ok end,
   fun(_) -> ok end,
   [
    fun() ->
        os:putenv("HTTP_TEST", "true"),
        wok_tests:request(get, <<"http://httpbin.org/get">>,
                          fun(Resp) ->
                              wok_tests:assert_response_ok(Resp),
                              wok_tests:assert_response_header({<<"Content-Type">>, <<"application/json">>}, Resp),
                              wok_tests:assert_response_has_body(Resp)
                          end),
        wok_tests:request(get, <<"http://httpbin.org/status/200">>,
                          fun(Resp) ->
                              wok_tests:assert_response_ok(Resp),
                              wok_tests:assert_response_not_has_body(Resp),
                              wok_tests:assert_response_body(<<"">>, Resp)
                          end)
    end
   ]}.
