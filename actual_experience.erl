-module(actual_experience).
-export([histogram/1, normalise/1]).

%%%% Question 1 - Histogram %%%%
histogram(Histogram) ->
    histogram(Histogram, generate_map(20, #{})).

histogram([], Map) ->
    maps:to_list(Map);

histogram([Head | Tail], Map) ->
    try maps:get(Head, Map) of
        Value ->
            UpdatedMap = maps:put(Head, Value + 1, Map),
            histogram(Tail, UpdatedMap)
    catch _:_ ->
        {error, {invalid_value, Head}}
    end.
    

% Generate the map that holds all the indicies
generate_map(0, Map) ->
    Map;

generate_map(Index, Map) ->
    UpdatedMap = maps:put(Index, 0, Map),
    generate_map(Index - 1, UpdatedMap).
%%%% Question 1 - Histogram %%%%

%%%% Question 2 - Histograms %%%%
normalise(Histograms) ->
    normalise(Histograms, generate_map(20, #{})).

normalise([], Histogram) ->
    FinalHistogram = maps:to_list(Histogram),
    {UpdatedHistogram, Total} = extract_values(FinalHistogram, 0, []),
    {UpdatedHistogram, calculate_distributrion(UpdatedHistogram, Total, [])};

normalise([Head | Tail], Map) ->
    try normalise_list(Head, Map) of
        UpdatedMap ->
            normalise(Tail, UpdatedMap)
    catch _:_ ->
        {error, {invalid_histogram, Head}}
    end.

normalise_list([{Key, NewValue} | Tail], Map) ->
    try maps:get(Key, Map) of
        OldValue ->
            UpdatedMap = maps:put(Key, OldValue + NewValue,
                Map),
            normalise_list(Tail, UpdatedMap)
    catch _:_ ->
        {error, {invalid_key, Key}}
    end;

normalise_list([], Map) ->
    Map.

extract_values([Head | Tail], Total, List) ->
    case Head of
        {_, 0} ->
            extract_values(Tail, Total, List);
        {Key, Value} ->
            extract_values(Tail, Total + Value, 
                lists:append(List, [{Key, Value}]))
    end;

extract_values([], Total, List) ->
    {List, Total}.

calculate_distributrion([{_, Value} | Tail], Total, List) ->
    calculate_distributrion(Tail, Total, lists:append(List, [Value/Total]));

calculate_distributrion([], _, List) ->
    List.
%%%% Question 2 - Histograms %%%%
