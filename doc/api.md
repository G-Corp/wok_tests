# Tests API

## provide/3

## provide/4

## provide/5

## provide/6

## request/2

```erlang
wok_tests:request(Method :: get | post | put | delete | patch,
                  URL :: string() | binary()) -> {ok, Code :: integer(), Headers :: list(), Body :: binary()}
                                                 | {error, Reason :: term()}.
```

```elixir
Wok.Tests.request(method :: :get | :post | :put | :delete | :patch,
                  url :: string() | binary()) -> {:ok, code :: integer(), headers :: list(), body :: binary()}
                                                 | {error, reason :: term()}
```

## request/3

```erlang
wok_tests:request(Method :: get | post | put | delete | patch,
                  URL :: string() | binary(),
                  Fun :: fun({ok, Code :: integer(), Headers :: list(), Body :: binary()}
                             | {error, Reason :: term()}) -> term().
```

```elixir
Wok.Tests.request(method :: :get | :post | :put | :delete | :patch,
                  url :: string() | binary(),
                  fun :: fun({:ok, code :: integer(), headers :: list(), body :: binary()}
                             | {:error, reason :: term()}) -> term().
```

## request/5

Send or simulate a HTTP request

Options :

  * `timeout :: integer()` : Request timeout
  * ̀`connect_timeout :: integer()` : Request connection timeout
  * `ssl :: ssloptions()̀  : SSL support
  * `autoredirect :: boolean()` : Auto redirect
  * `proxy_auth :: {userstring(), passwordstring()}` : Prox authentification.
  * `version :: http_version()` : HTTP version
  * `relaxed :: boolean()`
  * `url_encode :: boolean()`
  * `sync :: boolean()`
  * `stream :: stream_to()`
  * `body_format :: body_format()`
  * `full_result :: boolean()`
  * `headers_as_is :: boolean()`
  * `socket_opts :: socket_opts()`
  * `receiver :: receiver()`
  * `ipv6_host_with_brackets :: boolean()`
  * `local_state :: any()`
  * `global_state :: any()`
  * `custom_data :: map()`

```erlang
wok_tests:request(Method :: get | post | put | delete | patch,
                  URL :: string() | binary(),
                  Headers :: [{binary(), binary()}],
                  Body :: binary(),
                  Options :: options()) -> {ok, Code :: integer(), Headers :: list(), Body :: binary()}
                                           | {error, Reason :: term()}.
```

```elixir
Wok.Tests.request(method :: :get | :post | :put | :delete | :patch,
                  url :: string() | binary(),
                  headers :: [{binary(), binary()}],
                  body :: binary(),
                  options :: options()) -> {:ok, code :: integer(), headers :: list(), body :: binary()}
                                           | {error, reason :: term()}
```

## request/6

Send or simulate a HTTP request

Options :

  * `timeout :: integer()` : Request timeout
  * ̀`connect_timeout :: integer()` : Request connection timeout
  * `ssl :: ssloptions()̀  : SSL support
  * `autoredirect :: boolean()` : Auto redirect
  * `proxy_auth :: {userstring(), passwordstring()}` : Prox authentification.
  * `version :: http_version()` : HTTP version
  * `relaxed :: boolean()`
  * `url_encode :: boolean()`
  * `sync :: boolean()`
  * `stream :: stream_to()`
  * `body_format :: body_format()`
  * `full_result :: boolean()`
  * `headers_as_is :: boolean()`
  * `socket_opts :: socket_opts()`
  * `receiver :: receiver()`
  * `ipv6_host_with_brackets :: boolean()`
  * `local_state :: any()`
  * `global_state :: any()`
  * `custom_data :: map()`

```erlang
wok_tests:request(Method :: get | post | put | delete | patch,
                  URL :: string() | binary(),
                  Headers :: [{binary(), binary()}],
                  Body :: binary(),
                  Options :: options()
                  Fun :: fun({ok, Code :: integer(), Headers :: list(), Body :: binary()}
                             | {error, Reason :: term()}) -> term().
```

```elixir
Wok.Tests.request(method :: :get | :post | :put | :delete | :patch,
                  url :: string() | binary(),
                  headers :: [{binary(), binary()}],
                  body :: binary(),
                  options :: options()
                  fun :: fun({:ok, code :: integer(), headers :: list(), body :: binary()}
                             | {:error, reason :: term()}) -> term().
```

## follow/2

## follow/3

## assert/1 

## assert_not/1

## assert_equal/2

## assert_not_equal/2

## assert_response_ok/1

## assert_response_code/2

## assert_response_not_code/2

## assert_response_has_body/1

## assert_response_not_has_body/1

## assert_response_body/2

## assert_response_redirect/1

## assert_response_not_found/1

## assert_response_header/2

## assert_request_ok/1

*Deprecated, use assert_response_ok/2*

## assert_request_code/2

*Deprecated, use assert_response_code/2*

## assert_request_not_code/2

*Deprecated, use assert_response_not_code/2*

## assert_request_has_body/1

*Deprecated, use assert_response_has_body/1*

## assert_request_not_has_body/1

*Deprecated, use assert_response_not_has_body/1*

## assert_request_redirect/1

*Deprecated, use assert_response_redirect/1*

## assert_request_not_found/1

*Deprecated, use assert_response_not_found/1*

## assert_request_header/2

*Deprecated, use assert_response_header/2*

## debug/1

## debug/2

