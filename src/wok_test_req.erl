% @hidden
-module(wok_test_req).
-behaviour(wok_req).

% wok_test_req-specific functions
-export([
    new/7
  , new/10
  , get_response_cookies/1]).

% wok_req behaviour
-export([
  reply/1
  , set_cookie/4
  , get_cookies/1
  , client_ip/1
  , client_port/1
  , body/1
  , has_body/1
  , body_length/1
  , method/1
  , path/1
  , header/3
  , headers/1
  , post_values/1
  , get_values/1
  , binding_values/1
]).

-type cookie_option() ::
         {max_age, non_neg_integer()}
       | {domain, binary()}
       | {path, binary()}
       | {secure, boolean()}
       | {http_only, boolean()}.

new(Method, URL, Headers, Body, Query, Bindings, Cookies) ->
  new(Method, URL, Headers, Body, Query, Bindings, Cookies, undefined, undefined, #{}).
new(Method, URL, Headers, Body, Query, Bindings, Cookies, LocalState, GlobalState, CustomData) ->
  Req0 = wok_req:new(?MODULE, #{url => bucs:to_string(URL),
                                method => Method,
                                headers => Headers,
                                body => bucs:to_binary(Body),
                                query => bucs:to_binary(Query),
                                bindings => Bindings,
                                cookies => Cookies,
                                response_cookies => []}),
  Req1 = wok_req:set_global_state(Req0, GlobalState),
  Req2 = wok_req:set_local_state(Req1, LocalState),
  wok_req:set_custom_data(Req2, CustomData).

-spec get_response_cookies(wok_req:wok_req()) -> [
    { iodata(),
      iodata(),
      [cookie_option()]}
  ].
get_response_cookies(Req) ->
  #{response_cookies := Cookies} = wok_req:get_http_req(Req),
  Cookies.

-spec reply(wok_req:wok_req()) -> term().
reply(Req) ->
  {ok,
   wok_req:get_response_code(Req),
   wok_req:get_response_headers(Req),
   wok_req:get_response_body(Req)}.

-spec set_cookie(wok_req:wok_req(),
                 iodata(),
                 iodata(),
                 [cookie_option()]) -> wok_req:wok_req().
set_cookie(Req, Name, Value, Options) ->
  #{response_cookies := Cookies} = WokTestReq = wok_req:get_http_req(Req),
  wok_req:set_http_req(Req, WokTestReq#{
    response_cookies => [{bucs:to_binary(Name), bucs:to_binary(Value), lists:keysort(1, Options)} | Cookies]
  }).

-spec get_cookies(wok_req:wok_req()) -> [{binary(), binary()}].
get_cookies(Req) ->
  #{cookies := ReqCookies} = wok_req:get_http_req(Req),
  ReqCookies.

-spec client_ip(wok_req:wok_req()) -> inet:ip_address().
client_ip(_Req) ->
  {127, 0, 0, 1}.

-spec client_port(wok_req:wok_req()) -> inet:port_number().
client_port(_Req) ->
  45678.

-spec body(wok_req:wok_req()) -> {ok | more, binary(), wok_req:wok_req()}.
body(Req) ->
  #{body := Body} = wok_req:get_http_req(Req),
  {ok, Body, Req}.

-spec has_body(wok_req:wok_req()) -> boolean().
has_body(Req) ->
  body_length(Req) > 0.

-spec body_length(wok_req:wok_req()) -> integer().
body_length(Req) ->
  #{body := Body} = wok_req:get_http_req(Req),
  size(Body).

-spec method(wok_req:wok_req()) -> term().
method(Req) ->
  #{method := Method} = wok_req:get_http_req(Req),
  Method.

-spec path(wok_req:wok_req()) -> term().
path(Req) ->
  #{url := URL} = wok_req:get_http_req(Req),
  case http_uri:parse(bucs:to_string(URL)) of
    {ok, {_, _, _, _, Path, _}} -> bucs:to_binary(Path);
    {ok, {_, _, _, _, Path, _, _}} -> bucs:to_binary(Path);
    _ -> <<"/">>
  end.

-spec header(wok_req:wok_req(), binary(), any()) -> binary() | any() | undefined.
header(Req, Name, Default) ->
  buclists:keyfind(Name, 1, headers(Req), Default).

-spec headers(wok_req:wok_req()) -> [{binary(), iodata()}].
headers(Req) ->
  #{headers := Headers} = wok_req:get_http_req(Req),
  Headers.

-spec post_values(term()) -> {ok, [{binary(), binary() | true}], term()}
                             | {error, term()}.
post_values(#{body := Body} = Req) ->
  {ok, parse_qs(Body), [], undefined, Req}.

-spec get_values(term()) -> {ok, [{binary(), binary() | true}], term()}
                            | {error, term()}.
get_values(#{query := Query} = Req) ->
  {ok, parse_qs(Query), Req}.

-spec binding_values(term()) -> {ok, [{binary(), binary() | true}], term()}
                                | {error, term()}.
binding_values(#{bindings := Bindings} = Req) ->
  {ok, Bindings, Req}.

% private

parse_qs(B) when is_list(B) ->
  parse_qs(bucs:to_binary(B));
parse_qs(<<63, B/binary>>) ->
  parse_qs(B);
parse_qs(B) ->
  parse_qs_name(B, [], <<>>).

parse_qs_name(<< $%, H, L, Rest/bits >>, Acc, Name) ->
  C = (unhex(H) bsl 4 bor unhex(L)),
  parse_qs_name(Rest, Acc, << Name/bits, C >>);
parse_qs_name(<< $+, Rest/bits >>, Acc, Name) ->
  parse_qs_name(Rest, Acc, << Name/bits, " " >>);
parse_qs_name(<< $=, Rest/bits >>, Acc, Name) when Name =/= <<>> ->
  parse_qs_value(Rest, Acc, Name, <<>>);
parse_qs_name(<< $&, Rest/bits >>, Acc, Name) ->
  case Name of
    <<>> -> parse_qs_name(Rest, Acc, <<>>);
    _ -> parse_qs_name(Rest, [{Name, true}|Acc], <<>>)
  end;
parse_qs_name(<< C, Rest/bits >>, Acc, Name) when C =/= $%, C =/= $= ->
  parse_qs_name(Rest, Acc, << Name/bits, C >>);
parse_qs_name(<<>>, Acc, Name) ->
  case Name of
    <<>> -> lists:reverse(Acc);
    _ -> lists:reverse([{Name, true}|Acc])
  end.

parse_qs_value(<< $%, H, L, Rest/bits >>, Acc, Name, Value) ->
  C = (unhex(H) bsl 4 bor unhex(L)),
  parse_qs_value(Rest, Acc, Name, << Value/bits, C >>);
parse_qs_value(<< $+, Rest/bits >>, Acc, Name, Value) ->
  parse_qs_value(Rest, Acc, Name, << Value/bits, " " >>);
parse_qs_value(<< $&, Rest/bits >>, Acc, Name, Value) ->
  parse_qs_name(Rest, [{Name, Value}|Acc], <<>>);
parse_qs_value(<< C, Rest/bits >>, Acc, Name, Value) when C =/= $% ->
  parse_qs_value(Rest, Acc, Name, << Value/bits, C >>);
parse_qs_value(<<>>, Acc, Name, Value) ->
  lists:reverse([{Name, Value}|Acc]).

unhex($0) ->  0;
unhex($1) ->  1;
unhex($2) ->  2;
unhex($3) ->  3;
unhex($4) ->  4;
unhex($5) ->  5;
unhex($6) ->  6;
unhex($7) ->  7;
unhex($8) ->  8;
unhex($9) ->  9;
unhex($A) -> 10;
unhex($B) -> 11;
unhex($C) -> 12;
unhex($D) -> 13;
unhex($E) -> 14;
unhex($F) -> 15;
unhex($a) -> 10;
unhex($b) -> 11;
unhex($c) -> 12;
unhex($d) -> 13;
unhex($e) -> 14;
unhex($f) -> 15.

