-module(wok_test_req_tests).

-include_lib("eunit/include/eunit.hrl").

wok_test_req_test_() ->
   [
     new_sets_request_properties(),
     set_cookie_sets_response_cookie()
   ].

new_sets_request_properties() ->
  Req = wok_test_req:new('POST',
                         "http://example.com/some/path",
                         [{<<"header">>, <<"headervalue">>}],
                         <<"body=bodyval">>,
                         <<"query=queryval">>,
                         [{<<"binding">>, <<"boundvalue">>}],
                         [{<<"mycookie">>, <<"myvalue">>}]),
  [
      ?_assertEqual('POST', wok_req:method(Req))
    , ?_assertEqual(true, wok_req:has_body(Req))
    , ?_assertEqual(12, wok_req:body_length(Req))
    , ?_assertMatch({ok, <<"body=bodyval">>, _}, wok_req:body(Req))
    , ?_assertEqual(<<"/some/path">>, wok_req:path(Req))
    , ?_assertEqual(<<"headervalue">>, wok_req:header(Req, <<"header">>, undefined))
    , ?_assertEqual([{<<"header">>, <<"headervalue">>}], wok_req:headers(Req))
    , ?_assertMatch({ok, [{<<"body">>, <<"bodyval">>}], _}, wok_req:post_values(Req))
    , ?_assertMatch({ok, [{<<"query">>, <<"queryval">>}], _}, wok_req:get_values(Req))
    , ?_assertMatch({ok, [{<<"binding">>, <<"boundvalue">>}], _}, wok_req:binding_values(Req))
    , ?_assertEqual([{<<"mycookie">>, <<"myvalue">>}], wok_req:get_cookies(Req))
  ].

set_cookie_sets_response_cookie() ->
  Req = wok_test_req:new('GET', "/", [], <<"">>, <<"">>, [], []),
  Req2 = wok_req:set_cookie(Req, <<"mycookie">>, <<"myvalue">>, []),
  ?_assertEqual([{<<"mycookie">>, <<"myvalue">>}], wok_test_req:get_response_cookies(Req2)).
