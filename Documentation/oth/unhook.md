# oth.unhook: (Function: function) -> ()
Removes a hook made with [oth.hook](hook.md).
```lua
local Target = newcclosure(function()
	return "Hello"
end)

oth.hook(Target, function()
	return "Goodbye"
end)

oth.unhook(Target)
print(Target()) --> Hello
```
# Aliases
| Library | Name |
| :- | :- |
| oth | un_hook |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The hooked function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
