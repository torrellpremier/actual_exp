-module(mytimer).
-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2]).

-export([start/1, call/1, cast/1, stop/1]).

%------------------------Public interface-------------------------%
% Specify the length of the timeout
start(Timeout) ->
    gen_server:start_link(?MODULE, Timeout, []).

% Invoke the 'call' functionality
call(Pid) ->
    gen_server:call(Pid, call).

% Invoke the 'cast' functionality
cast(Pid) ->
    gen_server:cast(Pid, cast).

% Stop the server
stop(Pid) ->
    gen_server:stop(Pid).
%------------------------Public interface-------------------------%

%----------------------gen_server interface-----------------------%
init(Timeout) ->
    WaitTimerStarted = erlang:system_time(millisecond),
    % Store the end time and the timeout value
    {ok, {WaitTimerStarted + Timeout, Timeout},
        Timeout}.

handle_call(_Message, _From, {WaitTimerEnd, _} = State) ->
    % Calculate the new end timeout
    NewTimeout = WaitTimerEnd - erlang:system_time(millisecond),
    {reply, ok, State, NewTimeout}.

handle_cast(_Message, {WaitTimerEnd, _} = State) ->
    % Calculate the new end timeout
    NewTimeout = WaitTimerEnd - erlang:system_time(millisecond),
    {noreply, State, NewTimeout}.

handle_info(timeout, {_, Timeout}) ->
    % Output the message and start the timeout again
    io:format("Hello World!~n"),
    WaitTimerStarted = erlang:system_time(millisecond),
    {noreply, {WaitTimerStarted + Timeout, Timeout},
        Timeout}.

%----------------------gen_server interface-----------------------%
