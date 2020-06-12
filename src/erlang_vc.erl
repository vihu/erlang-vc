-module(erlang_vc).

-export([new/0, incremented/2, is_equal/2, temporal_relation/2, merge_with/2, to_vec/1]).
-export([load/0]).
-on_load(load/0).

load() ->
    erlang:load_nif(filename:join(priv(), "libnative"), none).

-spec new()-> {ok, reference()} | {error, any()}.
new() ->
    not_loaded(?LINE).

-spec incremented(reference(), string()) -> {ok, reference()} | {error, any()}.
incremented(_, _) ->
    not_loaded(?LINE).

-spec is_equal(reference(), reference()) -> boolean().
is_equal(_, _) ->
    not_loaded(?LINE).

-spec temporal_relation(reference(), reference()) -> atom().
temporal_relation(_, _) ->
    not_loaded(?LINE).

-spec merge_with(reference(), reference()) -> atom().
merge_with(_, _) ->
    not_loaded(?LINE).

-spec to_vec(reference()) -> [{string(), pos_integer()}].
to_vec(_) ->
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

