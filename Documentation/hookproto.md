# hookproto: (Proto: function, Hook: (...any) -> ...any) -> ()
Replaces a function defined inside of another function, including new copies of it.
```lua
local function Outer()
	return function()
		return "Hello"
	end
end

hookproto(debug.getproto(Outer, 1), function()
	return "Goodbye"
end)

print(Outer()()) --> Goodbye
```
# Aliases
| Library | Name |
| :- | :- |
| | hook_proto |
# Parameters
| Proto: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The inner function from debug.getproto.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Hook: (...any) -> ...any | The function to run instead. |
