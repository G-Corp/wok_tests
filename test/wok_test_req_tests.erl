-module(wok_test_req_tests).

-include_lib("eunit/include/eunit.hrl").

get_cookies_test() ->
  WokTestReq = wok_test_req:new('GET', "/", [{<<"cookies">>, <<" abc=abc; def=def">>}], <<"">>, <<"">>, [], [{<<"ghi">>, <<"ghi">>}]),
  ?assertEqual(
    [{<<"abc">>, <<"abc">>},{<<"def">>, <<"def">>},{<<"ghi">>, <<"ghi">>}],
    wok_test_req:get_cookies(WokTestReq)
  ).
