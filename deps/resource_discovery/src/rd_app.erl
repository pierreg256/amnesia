-module(rd_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
	case rd_sup:start_link() of
		{ok, Pid} -> 
			{ok, Pid};
		Error ->
			io:format("ici j'ai une erreur ~p", Error),
			Error
	end.


stop(_State) ->
	ok.
