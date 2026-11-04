# oth.get_root_callback: () -> function
Returns a function from inside of a hook made with [oth.hook](hook.md). Only works inside of the hook.
```lua
local Target = newcclosure(function() end)

oth.hook(Target, function()
	print(oth.get_root_callback())
end)

Target()
```
# Aliases
| Library | Name |
| :- | :- |
| oth | getrootcallback |
# Returns
| [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | A function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
