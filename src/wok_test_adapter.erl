% @hidden
-module(wok_test_adapter).
-include_lib("eunit/include/eunit.hrl").

-export([run/5]).

run(Method, URL, Headers, Body, _Options) ->
  case find_controler(
         bucs:to_atom(string:to_upper(bucs:to_string(Method))),
         URL) of
    {{Handler, Function}, URL1, Bindings, Query} -> 
      Req = wok_test_req:new(bucs:to_binary(string:to_upper(bucs:to_string(Method))), 
                             URL1, Headers, Body, Query, Bindings, []),
      Req1 = erlang:apply(Handler, Function, [Req]),
      wok_req:reply(Req1);
    not_found ->
      {ok, 404, [], <<>>}
  end.

find_controler(Method, URL) ->
  {URL1, 
   Path1, 
   Query1} = case http_uri:parse(bucs:to_string(URL)) of
               {ok, {_, _, _, _, Path, Query}} -> {URL, string:tokens(bucs:to_string(Path), "/"), Query};
               {ok, {_, _, _, _, Path, Query, _}} -> {URL, string:tokens(bucs:to_string(Path), "/"), Query};
               _ -> 
                 case http_uri:parse("http://example.com" ++ bucs:to_string(URL)) of
                   {ok, {_, _, _, _, Path, Query}} -> {"http://example.com" ++ bucs:to_string(URL),
                                                       string:tokens(bucs:to_string(Path), "/"), 
                                                       Query};
                   {ok, {_, _, _, _, Path, Query, _}} -> {"http://example.com" ++ bucs:to_string(URL),
                                                          string:tokens(bucs:to_string(Path), "/"), 
                                                          Query};
                   _ -> {URL, string:tokens(bucs:to_string(URL), "/"), []}
                 end
             end,
  {Routes, _} = wok_http_handler:routes(),
  lists:foldl(fun
                ({Route, Handlers}, Acc) when is_list(Handlers) ->
                  case lists:keyfind(Method, 1, Handlers) of
                    {Method, Result} ->
                      RouteTokens = string:tokens(bucs:to_string(Route), "/"),
                      if
                        length(RouteTokens) == length(Path1) ->
                          Bindings = lists:flatmap(fun
                                                     ({X,X}) -> []; 
                                                     ({":" ++ X, Y}) -> [{bucs:to_atom(X), Y}];
                                                     ({_, _}) -> [notmatch]
                                                   end, lists:zip(RouteTokens, Path1)),
                          case lists:member(notmatch, Bindings) of
                            true -> Acc;
                            false -> {Result, URL1, Bindings, Query1}
                          end;
                        true ->
                          Acc
                      end;
                    _ ->
                      Acc
                  end;
                (_, Acc) ->
                  Acc
              end, not_found, Routes).

