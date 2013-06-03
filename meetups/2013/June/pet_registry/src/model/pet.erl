-module(pet, [Id, Name, Kind]).
-compile(export_all).

validation_tests() ->
   [
      {
         fun() ->
            length(Name) > 0
         end,
         "Pet must have a name"
      },
      {
         fun() ->
            length(Kind) > 0
         end,
         "Pet must have a kind"
      }

   ].
