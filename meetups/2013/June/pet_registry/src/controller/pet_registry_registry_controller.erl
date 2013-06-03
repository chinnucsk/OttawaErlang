-module(pet_registry_registry_controller, [Req]).
-compile(export_all).

browse('GET', []) ->
   Pets = boss_db:find(pet, []),
   {ok, [{pets, Pets}]}.

edit('GET', [Id]) ->
   Pet = boss_db:find(Id),
   {ok, [{pet, Pet}]}.

add('GET', []) ->
   {ok, []}.

save('POST', []) ->
   Name = Req:post_param("Name"),
   Kind = Req:post_param("Kind"),
   NewPet = pet:new(id, Name, Kind),
   {ok, _} = NewPet:save(),
   {redirect, [{action, "browse"}]};

save('POST', [Id]) ->
   Name = Req:post_param("Name"),
   Kind = Req:post_param("Kind"),
   Pet = boss_db:find(Id),
   NewPet = Pet:set([{name, Name}, {kind, Kind}]),
   {ok, _} = NewPet:save(),
   {redirect, [{action, "browse"}]}.

delete('GET', [Id]) ->
   boss_db:delete(Id),
   {redirect, [{action, "browse"}]}.
