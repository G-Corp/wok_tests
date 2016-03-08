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
        wok_tests:request(get, <<"http://www.google.fr">>, 
                          fun(Resp) ->
                              wok_tests:assert_request_ok(Resp),
                              wok_tests:assert_request_has_body(Resp),
                              wok_tests:assert_request_header({<<"Transfer-Encoding">>, <<"chunked">>}, Resp)
                          end)
    end
   ]}.
