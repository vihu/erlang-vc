-module(erlang_vc).

-export([new/0]).
-export([load/0]).
-on_load(load/0).

load() ->
    erlang:load_nif(filename:join(priv(), "libnative"), none).

-spec new()-> {ok, reference()} | {error, any()}.
new() ->
    not_loaded(?LINE).

not_loaded(Line) ->
    erlang:nif_error({error, {not_loaded, [{module, ?MODULE}, {line, Line}]}}).

priv()->
    case code:priv_dir(?MODULE) of
        {error, _} ->
            EbinDir = filename:dirname(code:which(?MODULE)),
            AppPath = filename:dirname(EbinDir),
            filename:join(AppPath, "priv");
        Path ->
            Path
    end.

