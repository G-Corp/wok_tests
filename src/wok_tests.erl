-module(wok_tests).
-include_lib("eunit/include/eunit.hrl").

-export([provide/3
         , provide/4
         , provide/5
         , provide/6
         , build_message/1
        ]).

% Helpers
-export([request/2
         , request/3
         , request/5
         , request/6
         , follow/2
         , follow/3
        ]).

% Assert
-export([assert/1 
         , assert_not/1
         , assert_equal/2
         , assert_not_equal/2
         , assert_request_ok/1
         , assert_request_code/2
         , assert_request_not_code/2
         , assert_request_has_body/1
         , assert_request_not_has_body/1
         , assert_request_redirect/1
         , assert_request_not_found/1
         , assert_request_header/2
         , assert_response_ok/1
         , assert_response_code/2
         , assert_response_not_code/2
         , assert_response_has_body/1
         , assert_response_not_has_body/1
         , assert_response_body/2
         , assert_response_redirect/1
         , assert_response_not_found/1
         , assert_response_header/2
        ]).

-export([
         debug/1,
         debug/2
        ]).

provide(Topic, To, Message) ->
  provide(Topic, <<"test">>, To, [], Message).

provide(Topic, To, Message, Fun) ->
  provide(Topic, <<"test">>, To, [], Message, Fun).

provide(_Topic, From, To, Headers, Message, Fun) ->
  lists:foreach(fun(R) ->
                    Fun(R)
                end, provide(_Topic, From, To, Headers, Message)).

provide(_Topic, From, To, Headers, Message) ->
  case os:getenv("KAFKA_TEST") of
    "true" -> [];
    _ -> 
      Paths = wok_message_path:get_message_path_handlers(
                doteki:get_env([wok, messages, services],
                               doteki:get_env([wok, messages, controlers], []))),
      Services = wok_message_path:get_message_handlers(To, Paths),
      lists:foldl(fun({Handler, Function}, Acc) ->
                      [erlang:apply(Handler, 
                                    Function, 
                                    [wok_msg:new(From, 
                                                 To, 
                                                 Headers, 
                                                 Message, 
                                                 <<"2591f795-7ed0-4668-99fb-7cddd4c3b90d">>)])|Acc]
                  end, [], [maps:get(X, Paths) || {X, _} <- Services])
  end.

build_message(Map) when is_map(Map) ->
  wok_msg:new(
    maps:get(from, Map, <<"from">>),
    maps:get(to, Map, <<"to">>),
    maps:get(headers, Map, []),
    maps:get(body, Map, <<>>),
    maps:get(uuid, Map, <<"5a9bea37-c811-4f09-afa0-87a33b37dff3">>)).

% @doc
% Send or simulate a HTTP request
%
% Example
% <pre>
% wok_tests:request(get, "http://localhost:8080", [], "", [], fun(Response) -> ... end)
% </pre>
%
% {timeout, timeout()} | {connect_timeout, timeout()} | {ssl, ssloptions()} | {essl, ssloptions()} | {autoredirect, boolean()} | {proxy_auth, {userstring(), passwordstring()}} | {version, http_version()} | {relaxed, boolean()} | {url_encode, boolean()}
% {sync, boolean()} | {stream, stream_to()} | {body_format, body_format()} | {full_result, boolean()} | {headers_as_is, boolean() | {socket_opts, socket_opts()} | {receiver, receiver()}, {ipv6_host_with_brackets, boolean()}}
% @end
request(Method, URL) ->
  request(Method, URL, [], <<>>, []).

request(Method, URL, Fun) ->
  request(Method, URL, [], <<>>, [], Fun).

request(Method, URL, Headers, Body, Options) when is_atom(Method),
                                                  is_binary(URL),
                                                  is_list(Headers),
                                                  is_binary(Body),
                                                  is_list(Options) ->
  case os:getenv("HTTP_TEST") of
    "true" ->
      _ = hackney:start(),
      Options0 = lists:keydelete(local_state, 1, Options),
      Options1 = lists:keydelete(global_state, 1, Options0),
      Options2 = lists:keydelete(custom_data, 1, Options1),
      case hackney:request(Method, bucs:to_binary(URL), Headers, bucs:to_binary(Body), Options2) of
        {ok, StatusCode, RespHeaders, ClientRef} ->
          case hackney:body(ClientRef) of
            {ok, RespBody} ->
              {ok, StatusCode, RespHeaders, RespBody};
            E -> 
              E
          end;
        {ok, StatusCode, RespHeaders} ->
          {ok, StatusCode, RespHeaders, <<>>};
        E ->
          E
      end;
    _ ->
      wok_test_adapter:run(Method, URL, Headers, Body, Options)
  end.

request(Method, URL, Headers, Body, Options, Fun) when is_atom(Method),
                                                       is_binary(URL),
                                                       is_list(Headers),
                                                       is_binary(Body),
                                                       is_list(Options),
                                                       is_function(Fun) ->
  Fun(request(Method, URL, Headers,Body, Options)).

follow(Method, URL) ->
  case http_uri:parse(bucs:to_string(URL)) of
    {ok, {Scheme, UserInfo, Host, Port, _, _}} ->
      Base = bucs:to_binary(
               case UserInfo of
                 [] -> bucs:to_string(Scheme) ++ "://" ++ 
                       Host ++ ":" ++ bucs:to_string(Port);
                 _ -> bucs:to_string(Scheme) ++ "://" ++ 
                      UserInfo ++ "@" ++ 
                      Host ++ ":" ++ bucs:to_string(Port)
               end),
      request(Method, URL, fun({ok, StatusCode, RespHeaders, <<>>}) when StatusCode >= 300, StatusCode < 400 ->
                               case get_header(<<"Location">>, RespHeaders) of
                                 <<>> -> {error, not_redirect};
                                 Location -> request(get, <<Base/binary, Location/binary>>)
                               end;
                              (X) ->
                               X
                           end);
    E ->
      E
  end.
follow(Method, URL, Fun) ->
  Fun(follow(Method, URL)).

assert(Boolean) ->
  ?assert(Boolean).

assert_not(Boolean) ->
  ?assertNot(Boolean).

assert_equal(Expected, Expression) ->
  ?assertEqual(Expected, Expression).

assert_not_equal(Expected, Expression) ->
  ?assertNotEqual(Expected, Expression).

% @deprecated Please use {@link wok_tests:assert_response_ok/1}
assert_request_ok(R) ->
  assert_response_ok(R).

% @deprecated Please use {@link wok_tests:assert_response_code/2}
assert_request_code(E, R) ->
  assert_response_code(E, R).

% @deprecated Please use {@link wok_tests:assert_response_not_code/2}
assert_request_not_code(E, R) ->
  assert_response_not_code(E, R).

% @deprecated Please use {@link wok_tests:assert_response_has_body/1}
assert_request_has_body(R) ->
  assert_response_has_body(R).

% @deprecated Please use {@link wok_tests:assert_response_not_has_body/1}
assert_request_not_has_body(R) ->
  assert_response_not_has_body(R).

% @deprecated Please use {@link wok_tests:assert_response_redirect/1}
assert_request_redirect(R) ->
  assert_response_redirect(R).

% @deprecated Please use {@link wok_tests:assert_response_not_found/1}
assert_request_not_found(R) ->
  assert_response_not_found(R).

% @deprecated Please use {@link wok_tests:assert_response_header/2}
assert_request_header(H, R) ->
  assert_response_header(H, R).

assert_response_ok({ok, Code, _, _}) ->
  ?assert(Code >= 200 andalso Code < 300);
assert_response_ok(_) ->
  ?assert(false).

assert_response_code(ExpectedCode, {ok, Code, _, _}) ->
  ?assertEqual(ExpectedCode, Code);
assert_response_code(_, _) ->
  ?assert(false).

assert_response_not_code(ExpectedCode, {ok, Code, _, _}) ->
  ?assertNotEqual(ExpectedCode, Code);
assert_response_not_code(_, _) ->
  ?assert(false).

assert_response_has_body({ok, _, _, Body}) ->
  ?assert(<<>> =/= Body);
assert_response_has_body(_) ->
  ?assert(false).

assert_response_not_has_body({ok, _, _, Body}) ->
  ?assert(<<>> =:= Body);
assert_response_not_has_body(_) ->
  ?assert(false).

assert_response_body(ExpectedBody, {ok, _, _, Body}) ->
  ?assertEqual(ExpectedBody, Body);
assert_response_body(_, _) ->
  ?assert(false).

assert_response_redirect({ok, Code, _, _}) ->
  ?assert(Code >= 300 andalso Code < 400);
assert_response_redirect(_) ->
  ?assert(false).

assert_response_not_found({ok, 404, _, _}) ->
  ?assert(true);
assert_response_not_found(_) ->
  ?assert(false).

assert_response_header({Header, Value}, {ok, _, Headers, _}) ->
  ?assertEqual(bucs:to_binary(Value), get_header(Header, Headers));
assert_response_header(_, _) ->
  ?assert(false).

debug(Fmt, Data) ->
  ?debugFmt(Fmt, Data).

debug(Data) ->
  ?debugMsg(Data).

get_header(Header, Headers) ->
  bucs:to_binary(buclists:keyfind(bucs:to_binary(Header), 1, Headers, <<>>)).

