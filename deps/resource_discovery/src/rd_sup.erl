-module(rd_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor Callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

start_link()->
	supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([])->
	ResourceDiscovery = {resource_discovery, {resource_discovery, start_link, []}, permanent, 2000, worker, [resource_discovery]},

	Children = [ResourceDiscovery],
	RestartStrategy = {one_for_one, 4, 3600},
	{ok, {RestartStrategy, Children}}.