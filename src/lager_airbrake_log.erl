%% This module allows to send messages to error_logger internally in lager_airbrake.
%% Logs will generate a recursive call, but will be filtered out in lager_airbrake_notifier:check_nofify_from_self/1.
-module(lager_airbrake_log).

%% API
-export([info/2, error/2]).
-export([from_self_mp/0]).
-export([check_from_self/2]).


%% ===================================================================
%% API
%% ===================================================================
-spec info(Message :: string(), Opts :: list()) -> ok.
info(Message, Opts) ->
    error_logger:info_msg(append_log_identifier(Message), Opts).

-spec error(Message :: string(), Opts :: list()) -> ok.
error(Message, Opts) ->
    error_logger:error_msg(append_log_identifier(Message), Opts).

-spec from_self_mp() -> any().
from_self_mp() ->
    {ok, FromSelfMp} = re:compile("\\[LAGER_AIRBRAKE\\]"),
    FromSelfMp.

-spec check_from_self(Message :: any(), FromSelfMp :: any()) -> boolean().
check_from_self(Message, FromSelfMp) ->
    case re:run(Message, FromSelfMp, [{capture, none}]) of
        match ->
            true;
        _ ->
            false
    end.

%% ===================================================================
%% Internal
%% ===================================================================
-spec append_log_identifier(Message :: string()) -> string().
append_log_identifier(Message) ->
    lists:concat(["[LAGER_AIRBRAKE] ", Message]).
