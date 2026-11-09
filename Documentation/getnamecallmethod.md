# getnamecallmethod: () -> string
Returns the name of the method being called, which is mainly useful inside of a __namecall hook.
```lua
local Original
Original = hookmetamethod(game, "__namecall", function(...)
	print(getnamecallmethod())
	return Original(...)
end)
```
# Aliases
| Name |
| :- |
| get_namecall_method |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The method's name.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the getnamecallmethod test, the function must:
- Return the method name used in a namecall, from inside the `__namecall` metamethod.
- Return `nil` or error on a new thread that never made a namecall.
