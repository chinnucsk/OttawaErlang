-module(pet_registry_registry_controller, [Req]).
-compile(export_all).

browse('GET', []) ->
   Pets = boss_db:find(pet, []),
   {ok, [{pets, Pets}]}.

add('GET', []) ->
   {ok, []};

%% Save a new pet
add('POST', []) ->
   Name = Req:post_param("Name"),
   Kind = Req:post_param("Kind"),
   NewPet = pet:new(id, Name, Kind),
   do_save(NewPet, [{action, "add"}], already_exists(Name)).

edit('GET', [Id]) ->
   Pet = boss_db:find(Id),
   {ok, [{pet, Pet}]};

%% Save an existing pet (i.e. edit and update details)
edit('POST', [Id]) ->
   Name = Req:post_param("Name"),
   Kind = Req:post_param("Kind"),
   Pet = boss_db:find(Id),

   IsDuplicate = case Pet:name() =:= Name of
      false ->
         % Name of current pet changed, so check to see if it would create a
         % duplicate
         already_exists(Name);
      true ->
         % Name didn't change
         false
   end,

   NewPet = Pet:set([{name, Name}, {kind, Kind}]),
   do_save(NewPet, [{action, "edit"}, {id, Id}], IsDuplicate).

delete('GET', [Id]) ->
   boss_db:delete(Id),
   {redirect, [{action, "browse"}]}.

do_save(Pet, FailAction, true) ->
   Errors = ["Name must not already exist"],
   {render_other, FailAction, [{errors, Errors}, {pet, Pet}]};
do_save(Pet, FailAction, false) ->
   case Pet:save() of
      {ok, _} ->
         {redirect, [{action, "browse"}]};
      {error, Errors} ->
         {render_other, FailAction, [{errors, Errors}, {pet, Pet}]}
   end.
         
already_exists(Name) ->
   case boss_db:find(pet, [name, equals, Name]) of
      [] -> false;
      _ -> true
   end.
