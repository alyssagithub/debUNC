# newcclosure: (Function: function) -> function
Wraps a function so that it looks like a C function.
```lua
local Wrapped = newcclosure(function()
	return "Hello world!"
end)

print(debug.info(Wrapped, "s")) --> [C]
print(Wrapped()) --> Hello world!
```
# Aliases
| Name |
| :- |
| new_c_closure |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to wrap.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The wrapped function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
