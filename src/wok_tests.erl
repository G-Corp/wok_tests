-module(wok_tests).
-include_lib("eunit/include/eunit.hrl").

% Helpers
-export([
         request/3,
         request/6,
         follow/3,
         submit/4
        ]).

% Assert
-export([assert/1, 
         assert_not/1,
         assert_equal/2,
         assert_not_equal/2,
         assert_request_ok/1,
         assert_request_code/2,
         assert_request_not_code/2,
         assert_request_has_body/1,
         assert_request_not_has_body/1,
         assert_request_redirect/1,
         assert_request_not_found/1,
         assert_request_header/2
        ]).

-export([
         debug/1,
         debug/2
        ]).

%% Example
%% <pre>
%% paris_test:request(get, "http://localhost:8080", [], "", [], fun(Response) -> ... end)
%% </pre>
%%
%% {timeout, timeout()} | {connect_timeout, timeout()} | {ssl, ssloptions()} | {essl, ssloptions()} | {autoredirect, boolean()} | {proxy_auth, {userstring(), passwordstring()}} | {version, http_version()} | {relaxed, boolean()} | {url_encode, boolean()}
%% {sync, boolean()} | {stream, stream_to()} | {body_format, body_format()} | {full_result, boolean()} | {headers_as_is, boolean() | {socket_opts, socket_opts()} | {receiver, receiver()}, {ipv6_host_with_brackets, boolean()}}

request(Method, URL, Fun) ->
  request(Method, URL, [], <<>>, [], Fun).

request(Method, URL, Headers, Body, Options, Fun) when is_atom(Method),
                                                       is_binary(URL),
                                                       is_list(Headers),
                                                       is_binary(Body),
                                                       is_list(Options),
                                                       is_function(Fun) ->
  case os:getenv("HTTP_TEST") of
    "true" ->
      _ = hackney:start(),
      Fun(case hackney:request(Method, bucs:to_binary(URL), Headers, bucs:to_binary(Body), Options) of
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
          end);
    _ ->
      Fun(wok_test_adapter:run(Method, URL, Headers, Body, Options))
  end.

follow(Method, URL, Fun) ->
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
                                 <<>> -> Fun({error, not_redirect});
                                 Location -> request(get, <<Base/binary, Location/binary>>, Fun)
                               end;
                              (X) ->
                               Fun(X)
                           end);
    E ->
      Fun(E)
  end.

submit(_FormName, _FormValue, _Assertions, _Continuations) ->
  todo.

assert(Boolean) ->
  ?assert(Boolean).

assert_not(Boolean) ->
  ?assertNot(Boolean).

assert_equal(Expected, Expression) ->
  ?assertEqual(Expected, Expression).

assert_not_equal(Expected, Expression) ->
  ?assertNotEqual(Expected, Expression).

assert_request_ok({ok, Code, _, _}) ->
  ?assert(Code >= 200 andalso Code < 300);
assert_request_ok(_) ->
  ?assert(false).

assert_request_code(ExpectedCode, {ok, Code, _, _}) ->
  ?assertEqual(ExpectedCode, Code);
assert_request_code(_, _) ->
  ?assert(false).

assert_request_not_code(ExpectedCode, {ok, Code, _, _}) ->
  ?assertNotEqual(ExpectedCode, Code);
assert_request_not_code(_, _) ->
  ?assert(false).

assert_request_has_body({ok, _, _, Body}) ->
  ?assert(<<>> =/= Body);
assert_request_has_body(_) ->
  ?assert(false).

assert_request_not_has_body({ok, _, _, Body}) ->
  ?assert(<<>> =:= Body);
assert_request_not_has_body(_) ->
  ?assert(false).

assert_request_redirect({ok, Code, _, _}) ->
  ?assert(Code >= 300 andalso Code < 400);
assert_request_redirect(_) ->
  ?assert(false).

assert_request_not_found({ok, 404, _, _}) ->
  ?assert(true);
assert_request_not_found(_) ->
  ?assert(false).

assert_request_header({Header, Value}, {ok, _, Headers, _}) ->
  ?assertEqual(bucs:to_binary(Value), get_header(Header, Headers));
assert_request_header(_, _) ->
  ?assert(false).


debug(Fmt, Data) ->
  ?debugFmt(Fmt, Data).

debug(Data) ->
  ?debugMsg(Data).

get_header(Header, Headers) ->
  bucs:to_binary(buclists:keyfind(bucs:to_binary(Header), 1, Headers, <<>>)).

