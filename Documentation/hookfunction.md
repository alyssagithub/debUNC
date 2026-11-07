# hookfunction: (Function: function, Hook: (...any) -> ...any) -> (...any) -> ...any
Replaces a function with another function, and returns a function that still runs the original.
```lua
local function Greet()
	return "Hello"
end

local Original = hookfunction(Greet, function()
	return "Goodbye"
end)

print(Greet()) --> Goodbye
print(Original()) --> Hello
```
# Aliases
| Name |
| :- |
| hook_closure |
| hook_func |
| hook_function |
| hookclosure |
| hookfunc |
| replace_closure |
| replaceclosure |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to hook.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Hook: (...any) -> ...any | The function to run instead. It's given the same values the original would get, and what it returns is used. |
# Returns
| (...any) -> ...any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | A function that runs the original. Give it the same values you'd give the original.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
