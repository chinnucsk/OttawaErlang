-module(pet_registry_registry_controller, [Req]).
-compile(export_all).

browse('GET', []) ->
   Pets = boss_db:find(pet, []),
   {ok, [{pets, Pets}]}.

edit('GET', [Id]) ->
   {ok, []}.

add('GET', []) ->
   {ok, []};

add('POST', []) ->
   Name = Req:post_param("Name"),
   Kind = Req:post_param("Kind"),
   NewPet = pet:new(id, Name, Kind),
   {ok, _} = NewPet:save(),
   {redirect, [{action, "browse"}]}.
