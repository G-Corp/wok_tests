-module(wok_helpers_tests).

-include_lib("eunit/include/eunit.hrl").

assert_test_() ->
  {setup,
   fun() -> 
       meck:new(wok_http_handler, [non_strict]),
       meck:expect(wok_http_handler, routes, 
                   fun() ->
                     {
                       [{
                       "/api/users/:id", [
                         {'PATCH', {fake_rest_handler, update}},
                         {'PUT', {fake_rest_handler, update}},
                         {'GET', {fake_rest_handler, show}}
                       ]},{
                       "/api/users", [
                         {'POST', {fake_rest_handler, create}},
                         {'GET', {fake_rest_handler, index}}
                       ]},{
                       "/api/get", [
                         {'GET', {fake_rest_handler, get}}
                       ]},{
                       "/about", [
                         {'GET', {fake_rest_handler, about}}
                       ]},{
                       "/chat/:id/private/:idroom", [
                         {'POST', {fake_rest_handler, chat}}
                       ]},{
                       "/public/[...]", cowboy_static,
                         {dir,"/tmp",
                           [{mimetypes,cow_mimetypes,all},{default_file,"index.html"}]}
                       }
                       ], #{static_path => "/tmp", static_route => "/public"}
                     }
                   end),
       meck:new(fake_rest_handler, [non_strict]),
       meck:expect(fake_rest_handler, chat, 
                   fun(Req) ->
                       Req
                   end)
   end,
   fun(_) -> 
       meck:unload(wok_http_handler),
       meck:unload(fake_rest_handler)
   end,
   [
    fun() ->
        os:putenv("HTTP_TEST", "false"),
        wok_tests:request(post, <<"/chat/123/private/456?name=John&mail=john.doe@example.com">>, [], <<>>, [], 
                          fun(Resp) ->
                              wok_tests:assert_request_ok(Resp)
                          end)
    end,
    fun() ->
        os:putenv("HTTP_TEST", "false"),
        wok_tests:request(post, <<"/missing/path">>, [], <<>>, [], 
                          fun(Resp) ->
                              wok_tests:assert_request_not_found(Resp)
                          end)
    end
   ]}.

