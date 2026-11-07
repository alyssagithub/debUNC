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
