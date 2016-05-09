-module(wok_test_req_tests).

-include_lib("eunit/include/eunit.hrl").

wok_test_req_test_() ->
   [
     new_sets_request_properties()
     , set_cookie_sets_response_cookie_and_sorts_options()
   ].

new_sets_request_properties() ->
  Req = wok_test_req:new('POST',
                         "http://example.com/some/path",
                         [{<<"header">>, <<"headervalue">>},
                          {<<"content-type">>, <<"application/x-www-form-urlencoded">>}],
                         <<"body=bodyval">>,
                         <<"query=queryval">>,
                         [{<<"binding">>, <<"boundvalue">>}],
                         [{<<"mycookie">>, <<"myvalue">>}],
                         [{<<"file1">>, <<"text/plain">>, <<"/tmp/xyz/file1.txt">>},
                          {<<"file2">>, <<"text/html">>, <<"/tmp/zyx/file2.html">>}]),
  [
      ?_assertEqual('POST', wok_req:method(Req))
    , ?_assertEqual(true, wok_req:has_body(Req))
    , ?_assertEqual(12, wok_req:body_length(Req))
    , ?_assertMatch({ok, <<"body=bodyval">>, _}, wok_req:body(Req))
    , ?_assertEqual(<<"/some/path">>, wok_req:path(Req))
    , ?_assertEqual(<<"headervalue">>, wok_req:header(Req, <<"header">>, undefined))
    , ?_assertEqual([{<<"header">>, <<"headervalue">>}, {<<"content-type">>, <<"application/x-www-form-urlencoded">>}], wok_req:headers(Req))
    , ?_assertMatch([{<<"body">>, <<"bodyval">>}], wok_req:get_post_values(Req))
    , ?_assertMatch([{<<"query">>, <<"queryval">>}], wok_req:get_get_values(Req))
    , ?_assertMatch([{<<"binding">>, <<"boundvalue">>}], wok_req:get_bind_values(Req))
    , ?_assertEqual([{<<"mycookie">>, <<"myvalue">>}], wok_req:get_cookies(Req))
    , ?_assertEqual([{<<"file1">>, <<"text/plain">>, <<"/tmp/xyz/file1.txt">>},
                     {<<"file2">>, <<"text/html">>, <<"/tmp/zyx/file2.html">>}],
                    wok_req:get_files(Req))
  ].

set_cookie_sets_response_cookie_and_sorts_options() ->
  Req = wok_test_req:new('GET', "/", [], <<"">>, <<"">>, [], []),
  Req2 = wok_req:set_cookie(Req, <<"mycookie">>, <<"myvalue">>, [{path, <<"/">>}, {max_age, 1234}]),
  ?_assertEqual([{<<"mycookie">>, <<"myvalue">>, [{max_age, 1234}, {path, <<"/">>}]}],
    wok_test_req:get_response_cookies(Req2)).

