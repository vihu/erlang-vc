-module(basic_test).

-include_lib("eunit/include/eunit.hrl").

empty_ordering_test() ->
    {ok, C1} = erlang_vc:new(),
    {ok, C2} = erlang_vc:new(),
    ?assertEqual(true, erlang_vc:is_equal(C1, C2)),
    ?assertEqual(equal, erlang_vc:temporal_relation(C1, C2)),
    ?assertEqual(equal, erlang_vc:temporal_relation(C2, C1)),
    ok.

incremented_ordering_test() ->
    {ok, C1} = erlang_vc:new(),
    {ok, C2} = erlang_vc:incremented(C1, <<"A">>),
    ?assertEqual(false, erlang_vc:is_equal(C1, C2)),
    ?assertEqual(caused, erlang_vc:temporal_relation(C1, C2)),
    ?assertEqual(effect_of, erlang_vc:temporal_relation(C2, C1)),
    ok.

diverged_test() ->
    {ok, Base} = erlang_vc:new(),
    {ok, C1} = erlang_vc:incremented(Base, <<"A">>),
    {ok, C2} = erlang_vc:incremented(Base, <<"B">>),
    ?assertEqual(false, erlang_vc:is_equal(C1, C2)),
    ?assertEqual(concurrent, erlang_vc:temporal_relation(C1, C2)),
    ?assertEqual(concurrent, erlang_vc:temporal_relation(C2, C1)),
    ok.

merged_test() ->
    {ok, Base} = erlang_vc:new(),
    {ok, C1} = erlang_vc:incremented(Base, <<"A">>),
    {ok, C2} = erlang_vc:incremented(Base, <<"B">>),
    {ok, M} = erlang_vc:merge_with(C1, C2),
    ?assertEqual(effect_of, erlang_vc:temporal_relation(M, C1)),
    ?assertEqual(caused, erlang_vc:temporal_relation(C1, M)),
    ?assertEqual(effect_of, erlang_vc:temporal_relation(M, C2)),
    ?assertEqual(caused, erlang_vc:temporal_relation(C2, M)),
    ok.

to_vec_test() ->
    {ok, C} = erlang_vc:new(),
    ?assertEqual([], erlang_vc:to_vec(C)),
    {ok, C1} = erlang_vc:incremented(C, <<"A">>),
    {ok, C2} = erlang_vc:incremented(C1, <<"A">>),
    ?assertEqual([{<<"A">>, 2}], erlang_vc:to_vec(C2)),
    {ok, C3} = erlang_vc:incremented(C2, <<"B">>),
    ?assertEqual([{<<"A">>, 2}, {<<"B">>, 1}], lists:sort(erlang_vc:to_vec(C3))),
    ok.
