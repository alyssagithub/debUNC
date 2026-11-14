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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to wrap. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [function](https://create.roblox.com/docs/luau/functions) | The wrapped function. |

# Test requirements
To pass the newcclosure test, the function must:
- Return a function whose source is `[C]` in `debug.info`.
- Return a new function, not the one it was given.
- Return the wrapped function's result every time it's called.
- Work with functions that yield.
- Pass through every returned value, including trailing `nil` values.
- Pass an error object thrown after a yield back to `pcall` unchanged.
