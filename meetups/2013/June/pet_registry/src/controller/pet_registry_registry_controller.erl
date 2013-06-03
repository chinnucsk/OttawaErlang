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
   case already_exists(Name) of
      false ->
         save_new(Name, Kind);
      true ->
         Errors = ["Name must not already exist"],
         {render_other, [{action, "add"}], [{errors, Errors}, {name, Name}, {kind, Kind}]}
   end;

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

save_new(Name, Kind) ->
   NewPet = pet:new(id, Name, Kind),
   case NewPet:save() of
      {ok, _} ->
         {redirect, [{action, "browse"}]};
      {error, Errors} ->
         {render_other, [{action, "add"}], [{errors, Errors}, {name, Name}, {kind, Kind}]}
   end.

% TODO: Don't allow edit to change name to already existing pet
% TODO: Generalize save_new so that it can also catch errors for edit

already_exists(Name) ->
   case boss_db:find(pet, [name, equals, Name]) of
      [] -> false;
      _ -> true
   end.
