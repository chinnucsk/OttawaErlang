defprotocol K9 do
   @doc "Returns whether it barks or not"
   def barks?(kind)
end

defimpl K9, for: BitString do
   def barks?("Dog") do
      true
   end
   def barks?(_) do
      false
   end
end

IO.puts K9.barks?("Cat")
IO.puts K9.barks?("Dog")
