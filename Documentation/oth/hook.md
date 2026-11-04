# oth.hook: (Function: function, Hook: (...any) -> ...any) -> (...any) -> ...any
Replaces a C function with a function that runs on a separate thread, and returns a function that still runs the original.
```lua
local Target = newcclosure(function()
	return "Hello"
end)

local Original = oth.hook(Target, function()
	return "Goodbye"
end)

print(Target()) --> Goodbye
```
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The C function to hook.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Hook: (...any) -> ...any | The function to run instead. It's given the same values the original would get, and what it returns is used. |
# Returns
| (...any) -> ...any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | A function that runs the original. Give it the same values you'd give the original.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
