-module(wok_tests).
-include_lib("eunit/include/eunit.hrl").

-export([
         start/1
        ]).

% Helpers
-export([
         create_req/3,
         request/3,
         request/6,
         follow/3,
         submit/4
        ]).

% Assert
-export([assert/1, 
         assert_not/1,
         assert_match/2,
         assert_not_match/2,
         assert_equal/2,
         assert_not_equal/2,
         assert_http_ok/1,
         assert_http_code/2,
         assert_http_not_code/2,
         assert_http_has_body/1,
         assert_http_not_has_body/1,
         assert_http_redirect/1,
         assert_http_not_found/1,
         assert_http_header/2
        ]).

-export([
         debug/1,
         debug/2
        ]).

-define(HTTP_OPTIONS, [{timeout, infinity},
                       {connect_timeout, infinity},
                       {autoredirect, false},
                       {version, "HTTP/1.1"}]).
-define(OPTIONS, [{sync, true},
                  {full_result, true}]).

start(AppName) ->
  hackney:start(),
  AppName:start().

create_req(URL, Headers, Body) ->
  wok_tests_req:new(URL, Headers, Body).

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
      end).

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

assert_match(Expected, Expression) ->
  ?assertMatch(Expected, Expression).

assert_not_match(Expected, Expression) ->
  ?assertNotMatch(Expected, Expression).

assert_equal(Expected, Expression) ->
  ?assertEqual(Expected, Expression).

assert_not_equal(Expected, Expression) ->
  ?assertNotEqual(Expected, Expression).

assert_http_ok(Req) ->
  Code = wok_req:get_response_code(Req),
  assert(Code >= 200 andalso Code < 300).

assert_http_code(ExpectedCode, Req) ->
  assert_equal(ExpectedCode, wok_req:get_response_code(Req)).

assert_http_not_code(ExpectedCode, Req) ->
  assert_not_equal(ExpectedCode, wok_req:get_response_code(Req)).

assert_http_has_body(Req) ->
  assert(<<>> =/= wok_req:get_response_body(Req)).

assert_http_not_has_body(Req) ->
  assert(<<>> =:= wok_req:get_response_body(Req)).

assert_http_redirect(Req) ->
  Code = wok_req:get_response_code(Req),
  assert(Code >= 300 andalso Code < 400).

assert_http_not_found(Req) ->
  Code = wok_req:get_response_code(Req),
  assert(Code =:= 404).

assert_http_header({Header, Value}, Req) ->
  assert(get_header(Header, wok_req:get_response_headers(Req)) =:= bucs:to_binary(Value)).

debug(Fmt, Data) ->
  ?debugFmt(Fmt, Data).

debug(Data) ->
  ?debugMsg(Data).

get_header(Header, Headers) ->
  bucs:to_binary(buclists:keyfind(bucs:to_binary(Header), 1, Headers, <<>>)).

