#!/bin/sh
cd `dirname $0`
#exec erl -sname node1 -pa $PWD/ebin $PWD/deps/*/ebin -boot start_sasl -s reloader -s resource_discovery -s simple_cache -s mydemo
exec erl -sname node1 -pa $PWD/ebin $PWD/deps/*/ebin -s sasl -s resource_discovery -s simple_cache -s mydemo
