defmodule HelloWorld do

   @doc "Say hello to the world!"
   def say_hello() do
      say_hello("World")
   end

   # Also supports function header pattern
   # matching like Erlang
   def say_hello("Bill") do
      IO.puts "Hi Bill!"
   end

   def say_hello(name) do
      IO.puts "Hello " <> name
   end

   def regex(name) do
      if Regex.run(%r/jim/i, name) do
         IO.puts "Jim was found"
      else
         IO.puts "Jim not found"
      end
   end

   def first([head|_]) do
      IO.puts "First: " <> head
   end

end

HelloWorld.say_hello()
HelloWorld.say_hello("John")
HelloWorld.say_hello("Bill")
HelloWorld.say_hello("Bill")
HelloWorld.first(["Bill", "John", "Mary"])
HelloWorld.regex("Bob")
HelloWorld.regex("Jim Bob")
