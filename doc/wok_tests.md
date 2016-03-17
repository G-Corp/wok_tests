

# Module wok_tests #
* [Function Index](#index)
* [Function Details](#functions)

<a name="index"></a>

## Function Index ##


<table width="100%" border="1" cellspacing="0" cellpadding="2" summary="function index"><tr><td valign="top"><a href="#assert-1">assert/1</a></td><td></td></tr><tr><td valign="top"><a href="#assert_equal-2">assert_equal/2</a></td><td></td></tr><tr><td valign="top"><a href="#assert_not-1">assert_not/1</a></td><td></td></tr><tr><td valign="top"><a href="#assert_not_equal-2">assert_not_equal/2</a></td><td></td></tr><tr><td valign="top"><a href="#assert_request_code-2">assert_request_code/2</a></td><td>(<em>Deprecated</em>.) </td></tr><tr><td valign="top"><a href="#assert_request_has_body-1">assert_request_has_body/1</a></td><td>(<em>Deprecated</em>.) </td></tr><tr><td valign="top"><a href="#assert_request_header-2">assert_request_header/2</a></td><td>(<em>Deprecated</em>.) </td></tr><tr><td valign="top"><a href="#assert_request_not_code-2">assert_request_not_code/2</a></td><td>(<em>Deprecated</em>.) </td></tr><tr><td valign="top"><a href="#assert_request_not_found-1">assert_request_not_found/1</a></td><td>(<em>Deprecated</em>.) </td></tr><tr><td valign="top"><a href="#assert_request_not_has_body-1">assert_request_not_has_body/1</a></td><td>(<em>Deprecated</em>.) </td></tr><tr><td valign="top"><a href="#assert_request_ok-1">assert_request_ok/1</a></td><td>(<em>Deprecated</em>.) </td></tr><tr><td valign="top"><a href="#assert_request_redirect-1">assert_request_redirect/1</a></td><td>(<em>Deprecated</em>.) </td></tr><tr><td valign="top"><a href="#assert_response_code-2">assert_response_code/2</a></td><td></td></tr><tr><td valign="top"><a href="#assert_response_has_body-1">assert_response_has_body/1</a></td><td></td></tr><tr><td valign="top"><a href="#assert_response_header-2">assert_response_header/2</a></td><td></td></tr><tr><td valign="top"><a href="#assert_response_not_code-2">assert_response_not_code/2</a></td><td></td></tr><tr><td valign="top"><a href="#assert_response_not_found-1">assert_response_not_found/1</a></td><td></td></tr><tr><td valign="top"><a href="#assert_response_not_has_body-1">assert_response_not_has_body/1</a></td><td></td></tr><tr><td valign="top"><a href="#assert_response_ok-1">assert_response_ok/1</a></td><td></td></tr><tr><td valign="top"><a href="#assert_response_redirect-1">assert_response_redirect/1</a></td><td></td></tr><tr><td valign="top"><a href="#build_message-1">build_message/1</a></td><td></td></tr><tr><td valign="top"><a href="#debug-1">debug/1</a></td><td></td></tr><tr><td valign="top"><a href="#debug-2">debug/2</a></td><td></td></tr><tr><td valign="top"><a href="#follow-2">follow/2</a></td><td></td></tr><tr><td valign="top"><a href="#follow-3">follow/3</a></td><td></td></tr><tr><td valign="top"><a href="#produce-3">produce/3</a></td><td></td></tr><tr><td valign="top"><a href="#produce-4">produce/4</a></td><td></td></tr><tr><td valign="top"><a href="#produce-5">produce/5</a></td><td></td></tr><tr><td valign="top"><a href="#produce-6">produce/6</a></td><td></td></tr><tr><td valign="top"><a href="#request-2">request/2</a></td><td> 
Send or simulate a HTTP request.</td></tr><tr><td valign="top"><a href="#request-3">request/3</a></td><td></td></tr><tr><td valign="top"><a href="#request-5">request/5</a></td><td></td></tr><tr><td valign="top"><a href="#request-6">request/6</a></td><td></td></tr></table>


<a name="functions"></a>

## Function Details ##

<a name="assert-1"></a>

### assert/1 ###

`assert(Boolean) -> any()`

<a name="assert_equal-2"></a>

### assert_equal/2 ###

`assert_equal(Expected, Expression) -> any()`

<a name="assert_not-1"></a>

### assert_not/1 ###

`assert_not(Boolean) -> any()`

<a name="assert_not_equal-2"></a>

### assert_not_equal/2 ###

`assert_not_equal(Expected, Expression) -> any()`

<a name="assert_request_code-2"></a>

### assert_request_code/2 ###

`assert_request_code(E, R) -> any()`

__This function is deprecated:__ Please use [`wok_tests:assert_response_code/2`](wok_tests.md#assert_response_code-2)

<a name="assert_request_has_body-1"></a>

### assert_request_has_body/1 ###

`assert_request_has_body(R) -> any()`

__This function is deprecated:__ Please use [`wok_tests:assert_response_has_body/1`](wok_tests.md#assert_response_has_body-1)

<a name="assert_request_header-2"></a>

### assert_request_header/2 ###

`assert_request_header(H, R) -> any()`

__This function is deprecated:__ Please use [`wok_tests:assert_response_header/2`](wok_tests.md#assert_response_header-2)

<a name="assert_request_not_code-2"></a>

### assert_request_not_code/2 ###

`assert_request_not_code(E, R) -> any()`

__This function is deprecated:__ Please use [`wok_tests:assert_response_not_code/2`](wok_tests.md#assert_response_not_code-2)

<a name="assert_request_not_found-1"></a>

### assert_request_not_found/1 ###

`assert_request_not_found(R) -> any()`

__This function is deprecated:__ Please use [`wok_tests:assert_response_not_found/1`](wok_tests.md#assert_response_not_found-1)

<a name="assert_request_not_has_body-1"></a>

### assert_request_not_has_body/1 ###

`assert_request_not_has_body(R) -> any()`

__This function is deprecated:__ Please use [`wok_tests:assert_response_not_has_body/1`](wok_tests.md#assert_response_not_has_body-1)

<a name="assert_request_ok-1"></a>

### assert_request_ok/1 ###

`assert_request_ok(R) -> any()`

__This function is deprecated:__ Please use [`wok_tests:assert_response_ok/1`](wok_tests.md#assert_response_ok-1)

<a name="assert_request_redirect-1"></a>

### assert_request_redirect/1 ###

`assert_request_redirect(R) -> any()`

__This function is deprecated:__ Please use [`wok_tests:assert_response_redirect/1`](wok_tests.md#assert_response_redirect-1)

<a name="assert_response_code-2"></a>

### assert_response_code/2 ###

`assert_response_code(ExpectedCode, X2) -> any()`

<a name="assert_response_has_body-1"></a>

### assert_response_has_body/1 ###

`assert_response_has_body(X1) -> any()`

<a name="assert_response_header-2"></a>

### assert_response_header/2 ###

`assert_response_header(X1, X2) -> any()`

<a name="assert_response_not_code-2"></a>

### assert_response_not_code/2 ###

`assert_response_not_code(ExpectedCode, X2) -> any()`

<a name="assert_response_not_found-1"></a>

### assert_response_not_found/1 ###

`assert_response_not_found(X1) -> any()`

<a name="assert_response_not_has_body-1"></a>

### assert_response_not_has_body/1 ###

`assert_response_not_has_body(X1) -> any()`

<a name="assert_response_ok-1"></a>

### assert_response_ok/1 ###

`assert_response_ok(X1) -> any()`

<a name="assert_response_redirect-1"></a>

### assert_response_redirect/1 ###

`assert_response_redirect(X1) -> any()`

<a name="build_message-1"></a>

### build_message/1 ###

`build_message(Map) -> any()`

<a name="debug-1"></a>

### debug/1 ###

`debug(Data) -> any()`

<a name="debug-2"></a>

### debug/2 ###

`debug(Fmt, Data) -> any()`

<a name="follow-2"></a>

### follow/2 ###

`follow(Method, URL) -> any()`

<a name="follow-3"></a>

### follow/3 ###

`follow(Method, URL, Fun) -> any()`

<a name="produce-3"></a>

### produce/3 ###

`produce(Topic, To, Message) -> any()`

<a name="produce-4"></a>

### produce/4 ###

`produce(Topic, To, Message, Fun) -> any()`

<a name="produce-5"></a>

### produce/5 ###

`produce(Topic, From, To, Headers, Message) -> any()`

<a name="produce-6"></a>

### produce/6 ###

`produce(Topic, From, To, Headers, Message, Fun) -> any()`

<a name="request-2"></a>

### request/2 ###

`request(Method, URL) -> any()`


Send or simulate a HTTP request

Example

```

 wok_tests:request(get, "http://localhost:8080", [], "", [], fun(Response) -> ... end)
```

{timeout, timeout()} | {connect_timeout, timeout()} | {ssl, ssloptions()} | {essl, ssloptions()} | {autoredirect, boolean()} | {proxy_auth, {userstring(), passwordstring()}} | {version, http_version()} | {relaxed, boolean()} | {url_encode, boolean()}
{sync, boolean()} | {stream, stream_to()} | {body_format, body_format()} | {full_result, boolean()} | {headers_as_is, boolean() | {socket_opts, socket_opts()} | {receiver, receiver()}, {ipv6_host_with_brackets, boolean()}}

<a name="request-3"></a>

### request/3 ###

`request(Method, URL, Fun) -> any()`

<a name="request-5"></a>

### request/5 ###

`request(Method, URL, Headers, Body, Options) -> any()`

<a name="request-6"></a>

### request/6 ###

`request(Method, URL, Headers, Body, Options, Fun) -> any()`

