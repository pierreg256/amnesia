%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(mydemo_resource).

-export([init/1, content_types_provided/2]).
-export([resource_exists/2, content_types_accepted/2]).
%%-export([content_types_accepted/2]).
-export([to_json/2, from_json/2]).
%% -export([generate_etag/2]).
-export([allowed_methods/2, delete_resource/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

allowed_methods(Req, State) ->
  {['GET', 'PUT', 'DELETE'], Req, State}.

%% GETs
content_types_provided(Req, State) ->
  {[{"application/json", to_json}], Req, State}.

%% PUTs etc
content_types_accepted(Req, State) ->
  {[{"application/json", from_json}], Req, State}.

resource_exists(Req, State) ->
  case wrq:path_info(item, Req) of
    undefined ->
      Items = [],
      {true, Req, Items};
    Item ->
      case simple_cache:lookup(Item) of
        {error, _}  ->
          {false, Req, State};
		    {ok, Value} ->
          {true, Req, {Item, Value}}
      end
  end.

delete_resource(Req, State) ->
  Item = wrq:path_info(item, Req),
  Result = case simple_cache:delete(Item) of
             ok ->
               true;
             {error, _} ->
               false
           end,
  {Result, Req, State}.

to_json(Req, {ItemName, ItemDesc}=State) ->
  io:format("responding: ~p/~p ~n", [ItemName, ItemDesc]),
  {mochijson2:encode(ItemDesc), Req, State};
to_json(Req, Items) ->
  {mochijson2:encode(Items), Req, Items}.

from_json(Req, State) ->
  Body = wrq:req_body(Req),
  ItemName = wrq:path_info(item, Req),
  ItemValue = mochijson2:decode(Body),
  case simple_cache:insert(ItemName, ItemValue) of
    ok ->
      Req1 = wrq:set_resp_header("Content-Type", "application/json", Req),
      Req2 = wrq:append_to_response_body(mochijson2:encode(ItemValue), Req1),
      {true, Req2, {ItemName, ItemValue}};
    _ ->
      {false, Req, State}
  end.

