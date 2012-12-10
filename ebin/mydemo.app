{application,mydemo,
             [{description,"mydemo"},
              {vsn,"0.1.0"},
              {modules,[mydemo,mydemo_app,mydemo_resource,mydemo_sup]},
              {registered,[]},
              {applications,[kernel,stdlib,inets,crypto,mochiweb,webmachine]},
              {mod,{mydemo_app,[]}},
              {env,[]}]}.
