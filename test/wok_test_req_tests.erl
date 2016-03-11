-module(wok_test_req_tests).

-include_lib("eunit/include/eunit.hrl").

wok_test_req_test_() ->
  {setup,
   fun setup/0, fun teardown/1,
   [
    ?_test(t_get_cookies())
   ]}.

setup() ->
  ok.

teardown(_) ->
  ok.

t_get_cookies() ->
  WokTestReq = wok_test_req:new('GET', "/", [{<<"cookies">>, <<" abc=a b c; def=def">>}], <<"">>, <<"">>, [], [{<<"ghi">>, <<"ghi">>}]),
  ?assertEqual(
    [{<<"ghi">>, <<"ghi">>}, {<<"abc">>, <<"a b c">>},{<<"def">>, <<"def">>}],
    wok_test_req:get_cookies(WokTestReq)
  ).
